%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fstream>
#include "analizador.tab.h"
void yyerror(const char *s);
%}

FILE* yyin; // Definir yyin como variable global

%option yylineno
%option noyywrap

CARACTER                   [!@#$%*()=-+{}|:;?.,~<>^_`/\\]

%%

"<AUTOMATA_AFN>"            { yylval.str=strdup(yytext);return AUTOMATA_AFN;} // Almacenar el contenido en yylval, requiere definir YYSTYPE en Bison
"<ALFABETO>"                { yylval.str=strdup(yytext);return ALFABETO;}
"</ALFABETO>"               { yylval.str=strdup(yytext);return ALFABETO_FIN;}
"<ESTADO>"                  { yylval.str=strdup(yytext);return ESTADO;}
"</ESTADO>"                 { yylval.str=strdup(yytext);return ESTADO_FIN;}
"<INICIAL>"                 { yylval.str=strdup(yytext);return INICIAL;}
"</INICIAL>"                { yylval.str=strdup(yytext);return INICIAL_FIN;}
"<FINAL>"                   { yylval.str=strdup(yytext);return FINAL;}
"</FINAL>"                  { yylval.str=strdup(yytext);return FINAL_FIN;}
"<TRANSICIONES>"            { yylval.str=strdup(yytext);return TRANSICIONES;}
"</TRANSICIONES>"           { yylval.str=strdup(yytext);return TRANSICIONES_FIN;}
"</AUTOMATA_AFN>"           { yylval.str=strdup(yytext);return AUTOMATA_AFN_FIN;}
[a-zA-Z]+                   { yylval.str=strdup(yytext);return LETRA;}
[0-9]+                      { yylval.num=atoi(yytext);return DIGITO;} // Almacena el número como un entero
"&"                         { yylval.str=strdup(yytext);return CADENA_VACIA;}
","                         { yylval.str=strdup(yytext);return COMA;}
[CARACTER]+                 { yylval.str=strdup(yytext);return CARACTER;}

[ \t\n]+                    { }// ignore whitespace

.                           {
                                std::ofstream errorFile("bitacoraErrores.txt", std::ios_base::app);
                                errorFile << "Error en la linea: " << yylineno << ", Caracter invalido: " << yytext << std::endl;
                                errorFile.close();
                            }

%%

