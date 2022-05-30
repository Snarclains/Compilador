// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

FILE  *yyin;

char pi[1000];

char a_comp[3];
char b_comp[3];

int pila[10];

int yystopparser = 0;
int p_pi = 0;
int p_pila = 0;
int declarados = 0;

int yyerror();
int yylex();

void generar_archivo_cod_inter();
void generar_assembler();
void insertar(char*);
void apilar();
void avanzar();
void desapilar_insertar(int);
void actualizar_tipo(char*);


%}

%left OP_SUM OP_RES
%left OP_MUL OP_DIV
%right OP_ASIG

/*CARACTERES*/
%token DIGITO
%token DIG_C_NUL	
%token LETRA
%token ESPACIO
%token INI_COM
%token FIN_COM
%token GUIONES
%token CHAR_COMA
%token CHAR_PUNTO
%token CHAR_PUNCO
%token CHAR_DOSPU

/*DECLARACIONES*/
%token CTE_INT
%token CTE_FLO
%token CTE_CHA
%token ID
%token CONTENIDO
%token COMENTARIO

/*OPERADORES*/
%token OP_ASIG
%token OP_SUM
%token OP_MUL
%token OP_RES
%token OP_DIV

/*COMPARADORES*/
%token OP_MAY
%token OP_MEN
%token OP_MAIG
%token OP_MEIG
%token OP_IGU
%token OP_NEG
%token OP_DIS
%token OP_DOPU
%token OP_AND
%token OP_OR

/*OTROS CARACTERES*/
%token LLA_A
%token LLA_C
%token PAR_A
%token PAR_C
%token COR_A
%token COR_C
%token FIN_SEN

/*PALABRAS RESERVADAS*/
%token IF
%token ELSE
%token WHILE
%token INT
%token FLOAT
%token CHAR
%token FOR
%token DECVAR
%token ENDDEC
%token WRITE
%token READ
%token AVG
%token INLIST

%%

/*REGLAS*/

programa_completo: programa {generar_archivo_cod_inter(); generar_assembler(); printf("Sintactico --> Compilacion OK\n");}

programa: sentencia | programa sentencia ; 

sentencia:  asignacion | iteracion | seleccion | declaracion | entrada_salida;

asignacion: ID {insertar("ID");} OP_ASIG expresion {insertar(":="); printf("Sintactico --> ASIGNACION\n");};

iteracion:  WHILE {insertar("@salto_if"); apilar(); avanzar(); insertar(":="); apilar(); insertar("ET");} PAR_A condicion PAR_C {insertar("CMP"); insertar(a_comp); insertar("@salto_if");} LLA_A programa LLA_C	{insertar("BI"); desapilar_insertar(p_pi); desapilar_insertar(p_pi); printf("Sintactico --> WHILE\n");};

/*seleccion:  IF {insertar("@salto_if"); apilar(); avanzar(); insertar(":=");} PAR_A condicion PAR_C {insertar("CMP"); insertar(a_comp); insertar("@salto_if");} LLA_A programa LLA_C {desapilar_insertar(p_pi); printf("Sintactico --> IF\n");}
            | IF {insertar("@salto_if"); apilar(); avanzar(); insertar(":=");} PAR_A condicion PAR_C {insertar("CMP"); insertar(a_comp); insertar("@salto_if");} LLA_A programa LLA_C ELSE {insertar("BI"); desapilar_insertar(p_pi+1); apilar(); avanzar();} LLA_A programa LLA_C {desapilar_insertar(p_pi); printf("Sintactico --> IF ELSE\n");};*/

seleccion:  IF PAR_A condicion PAR_C LLA_A programa LLA_C {printf("Sintactico --> IF\n");}
            | IF PAR_A condicion PAR_C LLA_A programa LLA_C ELSE LLA_A programa LLA_C {printf("Sintactico --> IF ELSE\n");};
condicion:  comparacion 
            | condicion {insertar("CMP"); insertar(a_comp); insertar("@salto_if");} OP_AND comparacion {printf("Sintactico --> AND\n");}
            | condicion {insertar("CMP"); insertar(b_comp); apilar(); avanzar();} OP_OR comparacion {desapilar_insertar(p_pi+4); printf("Sintactico --> OR\n");}
            | PAR_A comparacion PAR_C;
comparacion:  expresion comparador expresion
              | expresion_INLIST {strcpy(a_comp,"BNE"); strcpy(b_comp,"BEQ"); printf("Sintactico --> INLIST\n");};
comparador: OP_MAIG   {strcpy(a_comp,"BLT"); strcpy(b_comp,"BGE");}
            | OP_MAY  {strcpy(a_comp,"BLE"); strcpy(b_comp,"BGT");}
            | OP_MEIG {strcpy(a_comp,"BGT"); strcpy(b_comp,"BLE");}
            | OP_MEN  {strcpy(a_comp,"BGE"); strcpy(b_comp,"BLT");}
            | OP_IGU  {strcpy(a_comp,"BNE"); strcpy(b_comp,"BEQ");}
            | OP_DIS  {strcpy(a_comp,"BEQ"); strcpy(b_comp,"BNE");};

declaracion: DECVAR lista_declaracion ENDDEC {printf("Sintactico --> DECLARACION\n");};
lista_declaracion:  lista_declaracion lista_id CHAR_DOSPU tipo | lista_id CHAR_DOSPU tipo;
lista_id: lista_id CHAR_COMA ID {declarados++;}
          | ID {declarados++;};
tipo: INT     {actualizar_tipo("int");}
      | FLOAT {actualizar_tipo("float");}
      | CHAR  {actualizar_tipo("char");};

entrada_salida: READ ID {printf("Sintactico --> READ ID\n");}
                | WRITE ID {printf("Sintactico --> WRITE ID\n");}
                | WRITE CTE_CHA {printf("Sintactico --> WRITE STR\n");};

expresion_AVG:  AVG {insertar("@avg");} PAR_A COR_A lista_expresion_avg COR_C PAR_C {insertar("+"); insertar("@cont_avg"); insertar("/");};
lista_expresion_avg:  lista_expresion_avg CHAR_COMA expresion {insertar("+"); insertar("@cont_avg"); insertar("@cont_avg"); insertar("1"); insertar("+"); insertar(":=");}
                     | expresion {insertar("@cont_avg"); insertar("@cont_avg"); insertar("1"); insertar("+"); insertar(":=");};

expresion_INLIST: INLIST {insertar("@salto_in"); apilar(); avanzar(); insertar(":=");} PAR_A ID {insertar("@aux_inlist"); insertar("ID"); insertar(":="); insertar("@aux_inlisted");} CHAR_PUNCO COR_A lista_expresion_inlist COR_C PAR_C {insertar("@aux_inlist"); insertar("@aux_inlisted");};
lista_expresion_inlist: lista_expresion_inlist CHAR_PUNCO {insertar("@aux_inlisted");} expresion {insertar(":="); insertar("CMP"); insertar("@salto_in");}
                        | expresion {insertar(":="); insertar("CMP"); insertar("BEQ"); insertar("@salto_in");};

expresion:  expresion OP_SUM termino {insertar("+"); printf("Sintactico --> SUMA\n");}
            | expresion OP_RES termino {insertar("-"); printf("Sintactico --> RESTA\n");}
            | expresion_AVG {printf("Sintactico --> AVG\n");}
            | termino;
termino:  termino OP_MUL factor {insertar("*"); printf("Sintactico --> MULTIPLICACION\n");}
          | termino OP_DIV factor {insertar("/"); printf("Sintactico --> DIVISION\n");}
          | factor;
factor: PAR_A expresion PAR_C 
        | ID {insertar("ID");}
        | CTE_CHA {insertar("CTE_CHA");}
        | CTE_FLO {insertar("CTE_FLO");}
        | CTE_INT {insertar("CTE_INT");};


%%


int main(int argc, char *argv[]){
  if((yyin = fopen(argv[1], "rt"))==NULL)
  {
    printf("Sintactico --> No se puede abrir el archivo de prueba: %s\n", argv[1]);
  }
  else
  { 
    yyparse();

    printf("Sintactico --> BISON finalizo la lectura del archivo %s \n", argv[1]);
  }

	fclose(yyin);

  return 0;
}

void generar_archivo_cod_inter(){
  FILE *pf;
	
  pf = fopen("polaca.txt", "wt");
	fputs(pi,pf);

  fclose(pf);
}

void generar_assembler(){
  //
}

//Inserta un elemento en la PI
void insertar(char* elemento){
  strcat(elemento,",");

  strcpy(&pi[p_pi],elemento);
  
  while(pi[p_pi] != '\0'){
    p_pi++;
  }
}

//Apila un numero de posicion de la PI
void apilar(){
  p_pila++;

  pila[p_pila] = p_pi;
}

//Avanza una posicion en la PI
void avanzar(){
  p_pi++;
}

//Desapila e inserta en la posicion recibida de PI
void desapilar_insertar(int p_polaca){
  int aux = pila[p_pila];

  p_pila--;

  pila[aux] = p_polaca;
}

//Inserta el type del ultimo ID registrado
void actualizar_tipo(char* type){
	FILE *pf;
	char strline[100];
  
  pf = fopen("ts.txt", "r+");

  while(declarados != 0){
    fseek(pf, -80*declarados, SEEK_END);
    fgets(strline, 99, pf);

    sprintf((strline+33),"|%-10s|%-32s|",type,"");

    fseek(pf, -80*declarados, SEEK_END);
    fputs(strline,pf);

    declarados--;
  }

  fclose(pf);
}

int yyerror(void){
  printf("Sintactico --> Error Sintactico\n");
	exit (1);
}
