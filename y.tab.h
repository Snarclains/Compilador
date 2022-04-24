
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     OP_RES = 258,
     OP_SUM = 259,
     OP_DIV = 260,
     OP_MUL = 261,
     OP_ASIG = 262,
     DIGITO = 263,
     DIG_C_NUL = 264,
     LETRA = 265,
     ESPACIO = 266,
     INI_COM = 267,
     FIN_COM = 268,
     GUIONES = 269,
     CHAR_COMA = 270,
     CHAR_PUNTO = 271,
     CHAR_PUNCO = 272,
     CHAR_DOSPU = 273,
     CTE_INT = 274,
     CTE_FLO = 275,
     CTE_CHA = 276,
     ID = 277,
     CONTENIDO = 278,
     COMENTARIO = 279,
     OP_MAY = 280,
     OP_MEN = 281,
     OP_MAIG = 282,
     OP_MEIG = 283,
     OP_IGU = 284,
     OP_NEG = 285,
     OP_DIS = 286,
     OP_DOPU = 287,
     OP_AND = 288,
     OP_OR = 289,
     LLA_A = 290,
     LLA_C = 291,
     PAR_A = 292,
     PAR_C = 293,
     FIN_SEN = 294,
     IF = 295,
     ELSE = 296,
     WHILE = 297,
     INT = 298,
     FLOAT = 299,
     CHAR = 300,
     FOR = 301,
     WRITE = 302,
     READ = 303,
     AVG = 304,
     INLIST = 305
   };
#endif
/* Tokens.  */
#define OP_RES 258
#define OP_SUM 259
#define OP_DIV 260
#define OP_MUL 261
#define OP_ASIG 262
#define DIGITO 263
#define DIG_C_NUL 264
#define LETRA 265
#define ESPACIO 266
#define INI_COM 267
#define FIN_COM 268
#define GUIONES 269
#define CHAR_COMA 270
#define CHAR_PUNTO 271
#define CHAR_PUNCO 272
#define CHAR_DOSPU 273
#define CTE_INT 274
#define CTE_FLO 275
#define CTE_CHA 276
#define ID 277
#define CONTENIDO 278
#define COMENTARIO 279
#define OP_MAY 280
#define OP_MEN 281
#define OP_MAIG 282
#define OP_MEIG 283
#define OP_IGU 284
#define OP_NEG 285
#define OP_DIS 286
#define OP_DOPU 287
#define OP_AND 288
#define OP_OR 289
#define LLA_A 290
#define LLA_C 291
#define PAR_A 292
#define PAR_C 293
#define FIN_SEN 294
#define IF 295
#define ELSE 296
#define WHILE 297
#define INT 298
#define FLOAT 299
#define CHAR 300
#define FOR 301
#define WRITE 302
#define READ 303
#define AVG 304
#define INLIST 305




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


