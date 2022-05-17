// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;

  int yyerror();
  int yylex();


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

programacompleto : programa {printf("Sintactico --> Compilacion OK\n");}

/* <programa> -> <sentencia> */
/* <programa> -> <programa> <sentencia>*/
programa: sentencia | programa sentencia ; 

/* <sentencia> -> <asignacion> */
/* <sentencia> -> <iteracion> */
/* <sentencia> -> <seleccion> */
/* <sentencia> -> <declaracion> */
sentencia:  asignacion
            |iteracion
            |seleccion
            |declaracion
            |entrada_salida;

/* <asignacion> -> ID OP_ASIG <expresion> */
asignacion: ID OP_ASIG expresion {printf("Sintactico --> ASIGNACION\n");};

/*<seleccion> -> IF PAR_A <condicion> PAR_C LLA_A <programa> LLA_C*/
/*<seleccion> -> IF PAR_A <condicion> PAR_C LLA_A <programa> LLA_C ELSE LLA_A <programa> LLA_C*/
seleccion:  IF PAR_A condicion PAR_C LLA_A programa LLA_C	{printf("Sintactico --> IF\n");}
            |IF PAR_A condicion PAR_C LLA_A programa LLA_C ELSE LLA_A programa LLA_C{printf("Sintactico --> IF ELSE\n");};

/* <declaracion> -> DECVAR <lista_declaracion> ENDDEC */
declaracion: DECVAR lista_declaracion ENDDEC {printf("Sintactico --> DECLARACION\n");};

/* <lista_declaracion> -> <lista_declaracion> <lista_id> CHAR_DOSPU <tipo> */
lista_declaracion: lista_declaracion lista_id CHAR_DOSPU tipo
                    |lista_id CHAR_DOSPU tipo;

/* <lista_id> -> <lista_id> CHAR_COMA ID */
lista_id: lista_id CHAR_COMA ID
          |ID;

/*<entrada_salida> -> WRITE */
entrada_salida: READ ID {printf("Sintactico --> READ ID\n");}
                | WRITE ID {printf("Sintactico --> WRITE ID\n");}
                | WRITE CTE_CHA {printf("Sintactico --> WRITE STR\n");};

/* <tipo> -> INT | FLOAT | CHAR */
tipo: INT
      |FLOAT
      |CHAR;

/*<iteracion> -> WHILE PAR_A <condicion> PAR_C LLA_A <programa> LLA_C*/
iteracion:  WHILE PAR_A condicion PAR_C LLA_A programa LLA_C	{printf("Sintactico --> WHILE\n");};

/*<condicion> -> <comparacion>*/
/*<condicion> -> <condicion> OP_AND <comparacion>*/
/*<condicion> -> <condicion> OP_OR <comparacion>*/
/*<condicion> -> <comparacion>*/
condicion:  comparacion 
            | condicion OP_AND comparacion {printf("Sintactico --> AND\n");}
            | condicion OP_OR comparacion {printf("Sintactico --> OR\n");}
            | PAR_A comparacion PAR_C;

/*<comparacion> -> <expresion> <comparador> <expresion>*/
comparacion:  expresion comparador expresion
              | expresion_INLIST {printf("Sintactico --> INLIST\n");};

/*<comparador> -> OP_MAIG | OP_MEIG | OP_MEN | OP_MAY | OP_IGU | OP_DIS*/
comparador: OP_MAIG 
            | OP_MEIG 
            | OP_MEN 
            | OP_MAY 
            | OP_IGU
            | OP_DIS;

/* <expresion> -> <expresion> + <termino> | <expresion> - <termino> | <termino>*/
expresion:  expresion OP_SUM termino {printf("Sintactico --> SUMA\n");}
            | expresion OP_RES termino {printf("Sintactico --> RESTA\n");}
            | expresion_AVG {printf("Sintactico --> AVG\n");}
            | termino;

expresion_AVG: AVG PAR_A COR_A lista_expresion_avg COR_C PAR_C ;
lista_expresion_avg: lista_expresion_avg CHAR_COMA expresion
                     | expresion;

expresion_INLIST: INLIST PAR_A ID CHAR_PUNCO COR_A lista_expresion_inlist COR_C PAR_C ;
lista_expresion_inlist: lista_expresion_inlist CHAR_PUNCO expresion
                        | expresion;


/* <termino> -> <termino> * <factor> | <termino> / <factor> | <factor>*/
termino:  termino OP_MUL factor {printf("Sintactico --> MULTIPLICACION\n");}
            | termino OP_DIV factor {printf("Sintactico --> DIVISION\n");}
            | factor;

/* <factor> -> (<expresion>) | ID | CTE*/
factor: PAR_A expresion PAR_C 
        | ID 
        | CTE_CHA
        | CTE_FLO
        | CTE_INT;


%%


int main(int argc, char *argv[])
{
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

int yyerror(void)
{
  printf("Sintactico --> Error Sintactico\n");
	exit (1);
}

