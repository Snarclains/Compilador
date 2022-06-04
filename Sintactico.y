// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

struct t_pi{
  char elemento[33];
};

FILE  *yyin;

struct t_pi pi[1000];

char a_comp[3];
char b_comp[3];
char ch_cont_avg[3];
char aux_salto[5];

int pila[10];

int yystopparser = 0;
int p_pi = 0;
int p_pila = -1;
int cont_avg = 0;
int declarados = 0;

int yyerror();
int yylex();

void generar_archivo_cod_inter();
void generar_assembler();
void insertar(char*);
void apilar();
void desapilar_insertar(int);
void actualizar_tipo(char*);
void cargar_simbolo_aux(char*, int, char*);

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

programa_completo:  programa {generar_archivo_cod_inter(); generar_assembler(); printf("Sintactico --> Compilacion OK\n");}

programa: sentencia | programa sentencia; 

sentencia:  asignacion | iteracion | seleccion | declaracion | entrada_salida;

asignacion: ID {insertar((char*)$1);} OP_ASIG expresion {insertar(":="); printf("Sintactico --> ASIGNACION\n");};

iteracion:  WHILE {cargar_simbolo_aux("@salto_if", 1, ""); insertar("@salto_if"); apilar(); insertar(":="); insertar("WHILE_ET"); sprintf(aux_salto,"%d",p_pi);}
              PAR_A condicion PAR_C {insertar("CMP"); insertar(a_comp); insertar("@salto_if");}
              LLA_A programa LLA_C {insertar("BI"); desapilar_insertar(2); insertar(aux_salto); printf("Sintactico --> WHILE\n");};

seleccion:      seleccion_aux {desapilar_insertar(1); printf("Sintactico --> IF\n");}
                | seleccion_aux ELSE {insertar("BI"); desapilar_insertar(1); apilar();} LLA_A programa LLA_C {desapilar_insertar(0); printf("Sintactico --> IF ELSE\n");};

seleccion_aux:  IF {cargar_simbolo_aux("@salto_if", 1, ""); insertar("@salto_if"); apilar(); insertar(":=");}
                  PAR_A condicion PAR_C {insertar("CMP"); insertar(a_comp); insertar("@salto_if");} LLA_A programa LLA_C;

condicion:      condicion {insertar("CMP"); insertar(a_comp); insertar("@salto_if");} OP_AND comparacion {printf("Sintactico --> AND\n");}
                | condicion {insertar("CMP"); insertar(b_comp); apilar();} OP_OR comparacion {desapilar_insertar(4); printf("Sintactico --> OR\n");}
                | comparacion;

comparacion:    expresion comparador expresion
                | expresion_INLIST {strcpy(a_comp,"BNE"); strcpy(b_comp,"BEQ"); printf("Sintactico --> INLIST\n");};

comparador:     OP_MAIG   {strcpy(a_comp,"BLT"); strcpy(b_comp,"BGE");}
                | OP_MAY  {strcpy(a_comp,"BLE"); strcpy(b_comp,"BGT");}
                | OP_MEIG {strcpy(a_comp,"BGT"); strcpy(b_comp,"BLE");}
                | OP_MEN  {strcpy(a_comp,"BGE"); strcpy(b_comp,"BLT");}
                | OP_IGU  {strcpy(a_comp,"BNE"); strcpy(b_comp,"BEQ");}
                | OP_DIS  {strcpy(a_comp,"BEQ"); strcpy(b_comp,"BNE");};

declaracion:        DECVAR lista_declaracion ENDDEC {printf("Sintactico --> DECLARACION\n");};

lista_declaracion:  lista_declaracion lista_id CHAR_DOSPU tipo | lista_id CHAR_DOSPU tipo;

lista_id:           lista_id CHAR_COMA ID {declarados++;}
                    | ID {declarados++;};

tipo:               INT     {actualizar_tipo("int");}
                    | FLOAT {actualizar_tipo("float");}
                    | CHAR  {actualizar_tipo("char");};

entrada_salida: READ {insertar("READ_ETIQ");} entrada_salida_aux {printf("Sintactico --> READ ID\n");}
                | WRITE {insertar("WRITE_ETIQ");} entrada_salida_aux {printf("Sintactico --> WRITE ID\n");};

entrada_salida_aux: ID {insertar((char*)$1);}
                    | CTE_CHA {insertar((char*)$1);};

expresion_AVG:        AVG {cargar_simbolo_aux("@avg", 1, ""); insertar("@avg");} PAR_A COR_A lista_expresion_avg COR_C 
                        PAR_C {sprintf(ch_cont_avg,"%d",cont_avg); cont_avg=0; insertar(ch_cont_avg); insertar("/");};

lista_expresion_avg:  lista_expresion_avg CHAR_COMA expresion {insertar("+"); cont_avg++;}
                      | expresion {cont_avg++;};

expresion_INLIST:       INLIST {cargar_simbolo_aux("@salto_in", 1, ""); insertar("@salto_in"); apilar(); insertar(":="); insertar("@aux_inlist");} PAR_A
                          id_aux_inlist {insertar(":="); insertar("@aux_inlisted");} CHAR_PUNCO COR_A lista_expresion_inlist COR_C 
                          PAR_C {desapilar_insertar(1); insertar("@aux_inlist"); insertar("@aux_inlisted"); strcpy(a_comp,"BNE"); strcpy(b_comp,"BEQ");};
id_aux_inlist: ID {insertar((char*)$1);};

lista_expresion_inlist: lista_expresion_inlist CHAR_PUNCO {cargar_simbolo_aux("@aux_inlist", 2, ""); insertar("@aux_inlisted"); cargar_simbolo_aux("@aux_inlisted", 2, ""); insertar("@aux_inlisted");} 
                          expresion {insertar(":="); insertar("@aux_inlist"); insertar("@aux_inlisted"); insertar("CMP"); insertar("BEQ"); insertar("@salto_in");}
                        | expresion {insertar(":="); insertar("@aux_inlist"); insertar("@aux_inlisted"); insertar("CMP"); insertar("BEQ"); insertar("@salto_in");};

expresion:  expresion OP_SUM termino {insertar("+"); printf("Sintactico --> SUMA\n");}
            | expresion OP_RES termino {insertar("-"); printf("Sintactico --> RESTA\n");}
            | expresion_AVG {printf("Sintactico --> AVG\n");}
            | termino;

termino:    termino OP_MUL factor {insertar("*"); printf("Sintactico --> MULTIPLICACION\n");}
            | termino OP_DIV factor {insertar("/"); printf("Sintactico --> DIVISION\n");}
            | factor;

factor:     PAR_A expresion PAR_C 
            | ID      {insertar((char*)$1);}
            | CTE_CHA {insertar((char*)$1);}
            | CTE_FLO {insertar((char*)$1);}
            | CTE_INT {insertar((char*)$1);};


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
  int i = 0;
	
  pf = fopen("intermedia.txt", "wt");

  while(strlen(pi[i].elemento) != 0){
    fputs(pi[i++].elemento,pf);
    fputs("\n",pf);
  }

  fclose(pf);
}

void generar_assembler(){
  //
}

//Inserta un elemento en la PI
void insertar(char* elemento){
  sprintf(pi[p_pi++].elemento,"%s",elemento);
}

//Apila un numero de posicion de la PI y avanza 1 posicion
void apilar(){
  pila[++p_pila] = p_pi++;
}

//Desapila e inserta en la posicion recibida de PI
void desapilar_insertar(int offset){
  int pos;
  char aux[5];

  pos = pila[p_pila];
  p_pila--;

  sprintf(aux,"%d",p_pi+offset);
  sprintf(pi[pos].elemento,"%s",aux);
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

/*Almacenar datos en tabla de simbolos - type 0(id) ,1(int), 2(float), 3(string)*/
void cargar_simbolo_aux(char* name, int type, char* val){
  FILE *pf, *pf_aux;
	char strline[100], straux[100], valaux[33], subline[33], subaux[33];
	
	if (fopen("ts.txt","r") == NULL){
		pf = fopen("ts.txt", "wt");
        fputs("NOMBRE                           |TIPO      |VALOR                           |LONGITUD\n",pf);
	}
	else
        pf = fopen("ts.txt", "at");
	
	switch (type){
		case 0:
			sprintf(straux, "%-33s|%-10s|%-32s|\n", name, "", "");
			break;
		case 1:
			sprintf(straux, "_%-32s|%-10s|%-32s|\n", name, "int", val);
			break;
		case 2:
			sprintf(straux, "_%-32s|%-10s|%-32s|\n", name, "float", val);
			break;
		case 3:
			strcpy(valaux,val+1);
      valaux[strlen(valaux)-1] = '\0';
			sprintf(straux, "_%-32s|%-10s|%-32s|%-10d\n", name, "string", valaux, strlen(valaux));
			break;
	}

    pf_aux = fopen("ts.txt", "rt");

	//Leo toda la linea en busca de duplicados
    while(fgets(strline, 99, pf_aux) != NULL)
    {
		strncpy(subline,strline,32);
		subline[32] = '\0';

		strncpy(subaux,straux,32);
		subaux[32] = '\0';

        if(strcmp(subline, subaux) == 0)
        {
            fclose(pf);
            fclose(pf_aux);
            return;
        }
    }
    
    fputs(straux,pf);

    fclose(pf_aux);
    fclose(pf);
}

int yyerror(void){
  printf("Sintactico --> Error Sintactico\n");
	exit (1);
}
