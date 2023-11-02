%{
#include <iostream>
#include <string>
#include <fstream>

//#define YYSTYPE std::string

extern char* yytext;
extern FILE *yyin;
extern int yylineno;
extern int yylex();

void yyerror(const char *s) { 
    std::ofstream errorFile("bitacoraErrores.txt", std::ios_base::app);
    errorFile << "Error en la linea " << yylineno << ": " << s << ", token erroneo: " << yytext << std::endl;
    errorFile.close();
}

std::ofstream outFile;

%}

%union {
    int num;
    char* str;
}

%token <str> AUTOMATA_AFN
%token <str> ALFABETO
%token <str> ALFABETO_FIN
%token <str> ESTADO
%token <str> ESTADO_FIN
%token <str> INICIAL
%token <str> INICIAL_FIN
%token <str> FINAL
%token <str> FINAL_FIN
%token <str> TRANSICIONES
%token <str> TRANSICIONES_FIN
%token <str> AUTOMATA_AFN_FIN
%token <str> LETRA
%token <num> DIGITO
%token <str> CARACTER
%token <str> CADENA_VACIA
%token <str> COMA

//%token <str> ERROR 

%error-verbose

%%

start: AUTOMATA_AFN alphabet states initial final transitions AUTOMATA_AFN_FIN
    | AUTOMATA_AFN error {yyerror("Se esperaba una etiqueta");} AUTOMATA_AFN_FIN
    ;

alphabet: ALFABETO {outFile << "<ALFABETO>\n";} symbols ALFABETO_FIN {outFile << "</ALFABETO>\n";}
    | ALFABETO error {yyerror("Se esperaba una letra o un caracter");} ALFABETO_FIN
    ;

symbols: LETRA { outFile << $1 << "\n"; } symbols
       | CARACTER { outFile << $1 << "\n"; } symbols
       | /* empty */
    ;

states: ESTADO {outFile << "<ESTADO>\n";} state_ids ESTADO_FIN {outFile << "</ESTADO>\n";}
    | ESTADO error yyerror{("Se esperaba un numero");} ESTADO_FIN
    ;

state_ids: DIGITO { outFile << $1 << "\n"; } state_ids
         | /* empty */
    ;

initial: INICIAL {outFile << "<INICIAL>\n";} initial_states INICIAL_FIN { outFile << "</INICIAL>\n";}
        | INICIAL error {yyerror("Se esperaba un numero");} INICIAL_FIN
    ;

initial_states: DIGITO { outFile << $1 << "\n"; } initial_states
               | /* empty */
    ;

final: FINAL {outFile << "<FINAL>\n"; } final_states FINAL_FIN { outFile << "</FINAL>\n";}
            | FINAL error {yyerror("Se esperaba un numero");} FINAL_FIN
    ;

final_states: DIGITO { outFile << $1 << "\n"; } final_states
            | /* empty */
    ;

transitions: TRANSICIONES {outFile << "<TANSICIONES>\n"} transition_rules TRANSICIONES_FIN { outFile << "</TRANSICIONES>\n";}
            | TRANSICIONES error {yyerror("Se esperaba una transicion valida con la forma 'n,a,m");} TRANSICIONES_FIN
           ;

transition_rules: DIGITO COMA CADENA_VACIA COMA DIGITO { outFile << $1 << ",&," << $5 << "\n"; } transition_rules
                | DIGITO COMA LETRA COMA DIGITO { outFile << $1 << "," << $3[0] << "," << $5 << "\n"; } transition_rules
                | /* empty */
    ;

%%

