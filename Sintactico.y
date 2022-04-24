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
%token WRITE
%token READ
%token AVG
%token INLIST

%%

/*REGLAS (REVISAR!)*/


programacompleto : programa {printf("Compilacion OK\n");}

/* <programa> -> <sentencia> */
/* <programa> -> <programa> <sentencia>*/
programa: sentencia | programa sentencia ; 

/* <sentencia> -> <asignacion> */
/* <sentencia> -> <iteracion> */
/* <sentencia> -> <seleccion> */
/* <sentencia> -> <definicion> */
sentencia:  asignacion
            |iteracion
            |seleccion
            |definicion;

/* <asignacion> -> ID OP_ASIG <seleccion> */
asignacion: ID OP_ASIG expresion {printf("ASIGNACION\n");};

/*<seleccion> -> IF PAR_A <condicion> PAR_C LLA_A <programa> LLA_C*/
/*<seleccion> -> IF PAR_A <condicion> PAR_C LLA_A <programa> LLA_C ELSE LLA_A <programa> LLA_C*/
seleccion:  IF PAR_A condicion PAR_C LLA_A programa LLA_C	{printf("IF\n");}
            |IF PAR_A condicion PAR_C LLA_A programa LLA_C ELSE LLA_A programa LLA_C{printf("IF ELSE\n");};

/* <definicion> -> tipo ID | tipo asignacion */
definicion: tipo ID {printf("DEFINICION\n");}
            | tipo asignacion {printf("DEFINICION CON ASIGNACION\n");}

/* <tipo> -> INT | FLOAT | CHAR */
tipo: INT
      |FLOAT
      |CHAR;

/*<iteracion> -> WHILE PAR_A <condicion> PAR_C LLA_A <programa> LLA_C*/
iteracion:  WHILE PAR_A condicion PAR_C LLA_A programa LLA_C	{printf("WHILE\n");};

/*<condicion> -> <comparacion>*/
/*<condicion> -> <condicion> OP_AND <comparacion>*/
/*<condicion> -> <condicion> OP_OR <comparacion>*/
/*<condicion> -> <comparacion>*/
condicion:  comparacion 
            | condicion OP_AND comparacion {printf("AND\n");}
            | condicion OP_OR comparacion {printf("OR\n");}
            | PAR_A comparacion PAR_C;

/*<comparacion> -> <expresion> <comparador> <expresion>*/
comparacion:  expresion comparador expresion;

/*<comparador> -> OP_MAIG | OP_MEIG | OP_MEN | OP_MAY | OP_IGU*/
comparador: OP_MAIG 
            | OP_MEIG 
            | OP_MEN 
            | OP_MAY 
            | OP_IGU;

/* <expresion> -> <expresion> + <termino> | <expresion> - <termino> | <termino>*/
expresion:  expresion OP_SUM termino {printf("SUMA\n");}
            | expresion OP_RES termino {printf("RESTA\n");}
            | expresion_AVG {printf("AVG\n");}
            | expresion_INLIST {printf("INLIST\n");}
            | lista {printf("lista\n");}
            | termino;

expresion_AVG: AVG PAR_A lista_elementos PAR_C ;
expresion_INLIST: INLIST PAR_A lista PAR_C;
lista: COR_A lista_elementos COR_C;

lista_elementos: termino CHAR_COMA lista_elementos;
lista_elementos: expresion;

/* <termino> -> <termino> * <factor> | <termino> / <factor> | <factor>*/
termino:  termino OP_MUL factor {printf("MULTIPLICACION\n");}
            | termino OP_DIV factor {printf("DIVISION\n");}
            | factor;

/* <factor> -> (<expresion>) | ID | CTE*/
factor: PAR_A expresion PAR_C 
        | ID 
        | CTE_CHA
        | CTE_FLO
        | CTE_INT;



/*
sentencia:  	   
	asignacion {printf(" FIN\n");} ;

asignacion: 
          ID OP_ASIG expresion {printf("    ID = Expresion es ASIGNACION\n");}
	  ;

expresion:
         termino {printf("    Termino es Expresion\n");}
	 |expresion OP_SUM termino {printf("    Expresion+Termino es Expresion\n");}
	 |expresion OP_RES termino {printf("    Expresion-Termino es Expresion\n");}
	 ;

termino: 
       factor {printf("    Factor es Termino\n");}
       |termino OP_MUL factor {printf("     Termino*Factor es Termino\n");}
       |termino OP_DIV factor {printf("     Termino/Factor es Termino\n");}
       ;

factor: 
      ID {printf("    ID es Factor \n");}
      | CTE_INT {printf("    CTE_INT es Factor\n");}
	| PAR_A expresion PAR_C {printf("    Expresion entre parentesis es Factor\n");}
     	;

    */
%%


int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
       
    }
    else
    { 
        
        yyparse();

        printf("\nBISON finalizo la lectura del archivo %s \n", argv[1]);
        
    }
	fclose(yyin);
        return 0;
}

int yyerror(void)
     {
       printf("Error Sintactico\n");
	 exit (1);
     }

