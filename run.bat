:: Script para windows
flex Lexico.l
bison -dyv Sintactico.y

gcc lex.yy.c y.tab.c -o Primera.exe

Primera.exe prueba.txt

@echo off

del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause
