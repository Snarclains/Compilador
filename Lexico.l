%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#include "y.tab.h"
FILE  *yyin;
int yylval;
char *yyltext;

int yyerror(void);

#define LIMIT_ID 32
#define LIMIT_STR 30


#define LIMIT_INT_INF -32768
#define LIMIT_INT_SUP 32767
#define LIMIT_FLOAT_INF pow(-1.17549,-38)
#define LIMIT_FLOAT_SUP pow(3.40282,38)


%}

/*OPCIONES*/
%option noyywrap  
%option yylineno 

/*TOKENS*/
DIGITO			[1-9]
DIG_C_NUL		[0-9]		
LETRA			[a-zA-Z]
ESPACIO			[" "]
INI_COM			["/*"]
FIN_COM			["*/"]
GUIONES			[-_]
CHAR_COMA		[","]
CHAR_PUNTO		["."]
CHAR_PUNCO		[";"]
CHAR_DOSPU		[":"]


/*DECLARACIONES*/
CTE_INT	    -?{DIGITO}{DIG_C_NUL}|0
CTE_FLO		(-?{DIGITO}{DIG_C_NUL}|0){CHAR_PUNTO}{DIGITO}*
CTE_CHA	    \"[^\n"]*\"
ID			{LETRA}({LETRA}|{DIGITO}|{GUIONES})*

/*OPERADORES*/
OP_ASIG		"="
OP_SUM		"+"
OP_MUL		"*"
OP_RES		"-"
OP_DIV		"/"
OP_MAY		">"
OP_MEN		"<"
OP_MAIG		">="
OP_MEIG		"<="
OP_IGU		"=="
OP_NEG		"!"
OP_DIS		"!="
OP_DOPU		":"

/*OTROS CARACTERES*/
LLA_A		"{"
LLA_C		"}"
PAR_A		"("
PAR_C		")"
FIN_SEN		";"

/*PALABRAS RESERVADAS*/
IF			"if"|"IF"|"If"
WHILE		"while"|"WHILE"|"While"
INT			"int"|"INT"|"Int"
FLOAT		"float"|"FLOAT"|"Float"
CHAR		"char"|"CHAR"|"Char"
FOR			"for"|"FOR"|"For"
WRITE		"write"|"WRITE"|"Write"
READ		"read"|"READ"|"Read"

%%

CHAR_COMA		{printf("\nComa: %s\n", yytext); return CHAR_COMA;}
CHAR_PUNTO		{printf("\nPunto: %s\n", yytext); return CHAR_PUNTO;}
CHAR_PUNCO		{printf("\nPunto y coma: %s\n", yytext); return CHAR_PUNCO;}
CHAR_DOSPU		{printf("\nDos puntos: %s\n", yytext); return CHAR_DOSPU;}

{CTE_INT}		{	
				if (atof(yytext) > LIMIT_INT_SUP || atof(yytext) < LIMIT_INT_INF) 
				{
                        	printf( "El entero supera los limites permitidos.\n");
                        	exit(1);
                    		} 
				printf("\nConstante entera: %s\n", yytext); return CTE_INT;
			}

{CTE_FLO}		{	
				if (atof(yytext) > LIMIT_FLOAT_SUP || atof(yytext) < LIMIT_FLOAT_INF) 
				{
                        	printf( "El real supera los limites permitidos. \n");
                        	exit(1);
                    		}  
				printf("\nConstante flotante: %s\n", yytext); return CTE_FLO;
			}

{CTE_CHA}		{
				if (strlen(yytext) > LIMIT_STR) 
				{
                        	printf( "El string ingresado supera la cantidad maxima permitida. Cantidad: %d\n", LIMIT_STR);
                        	exit(1); 
				}
				printf("\nConstante char: %s\n", yytext); return CTE_CHA;
			}

{ID}			{	
				if (strlen(yytext) > LIMIT_ID) 
				{
                        	printf( "El nombre del identificador supera la cantidad maxima de caracters permitidos. Cantidad: %d\n", LIMIT_ID);
                       	 	exit(1);
                    		}
				printf("\nIdentificador: %s\n", yytext);return ID;
			}

{OP_SUM}		{printf("\nSuma: %s\n", yytext); return OP_SUM;}
{OP_ASIG}		{printf("\nAsignacion: %s\n", yytext); return OP_AS;}
{OP_MUL}		{printf("\nMultiplicacion: %s\n", yytext); return OP_MUL;}
{OP_RES}		{printf("\nResta: %s\n", yytext); return OP_RES;}
{OP_DIV}		{printf("\nDivision: %s\n", yytext); return OP_DIV;}
{OP_MAY}		{printf("\nMayor: %s\n", yytext); return OP_MAY;}
{OP_MEN}		{printf("\nMenor: %s\n", yytext); return OP_MEN;}
{OP_MAIG}		{printf("\nMayor igual: %s\n", yytext); return OP_MAIG;}
{OP_MEIG}		{printf("\nMenor igual: %s\n", yytext); return OP_MEIG;}
{OP_IGU}		{printf("\nIguales: %s\n", yytext); return OP_IGU;}
{OP_NEG}		{printf("\nNegacion: %s\n", yytext); return OP_NEG;}
{OP_DIS}		{printf("\nDistinto: %s\n", yytext); return OP_DIS;}
{OP_DOPU}		{printf("\nDos puntos: %s\n", yytext); return OP_DOPU;}

{PAR_A}			{printf("\nParentesis abre: %s\n", yytext); return PAR_A;}
{PAR_C}			{printf("\nParentesis cierra: %s\n", yytext); return PAR_C;}
{LLA_A}			{printf("\nLlave abre: %s\n", yytext); return LLA_A;}
{LLA_C}			{printf("\nLlave cierra: %s\n", yytext); return LLA_C;}
{FIN_SEN}		{printf("\nFin de sentencia: %s\n", yytext); return FIN_SEN;}

{IF}			{printf("\nPalabra reservada IF: %s\n", yytext); return IF;}
{WHILE}			{printf("\nPalabra reservada WHILE: %s\n", yytext); return WHILE;}
{INT}			{printf("\nPalabra reservada INT: %s\n", yytext); return INT;}
{FLOAT}			{printf("\nPalabra reservada FLOAT: %s\n", yytext); return FLOAT;}
{CHAR}			{printf("\nPalabra reservada CHAR: %s\n", yytext); return CHAR;}
{FOR}			{printf("\nPalabra reservada FOR: %s\n", yytext); return FOR;}
{WRITE}			{printf("\nPalabra reservada WRITE: %s\n", yytext); return WRITE;}
{READ}			{printf("\nPalabra reservada READ: %s\n", yytext); return READ;}

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			 {printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}
"ñ"			 {printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}
"Ñ"			 {printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}

%%

int main (int argc, char *argv[]){
	if((yyin = fopen(argv[1], "rt")) == NULL){
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
		exit(0);
	}

	printf("\nEl archivo %s se abrio correctamente\n", argv[1]);
	yylex();

	printf("\nFLEZ finalizo la lectura del archivo %s \n", argv[1]);
	fclose(yyin);

	return 0;
}

