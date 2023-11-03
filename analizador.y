%{
#include <iostream>
#include <string>
#include <fstream>
#include "afn.h"

//#define YYSTYPE std::string

extern char* yytext;
extern FILE *yyin;
extern int yylineno;
extern int yylex();

extern void yyerror(const char *s);

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
    | AUTOMATA_AFN error AUTOMATA_AFN_FIN
    ;

alphabet: ALFABETO {alfabeto.insert('&');} symbols ALFABETO_FIN 
    | ALFABETO error ALFABETO_FIN
    ;

symbols: LETRA { alfabeto.insert($1[0]); } symbols
       | CARACTER { alfabeto.insert($1[0]); } symbols
       | /* empty */
    ;

states: ESTADO state_ids ESTADO_FIN
    | ESTADO error ESTADO_FIN
    ;

state_ids: DIGITO { estados.insert($1); } state_ids
         | /* empty */
    ;

initial: INICIAL initial_states INICIAL_FIN
        | INICIAL error INICIAL_FIN
    ;

initial_states: DIGITO { estadoInicial = $1; } initial_states
               | /* empty */
    ;

final: FINAL final_states FINAL_FIN
            | FINAL error FINAL_FIN
    ;

final_states: DIGITO { estadosFinales.insert($1); } final_states
            | /* empty */
    ;

transitions: TRANSICIONES transition_rules TRANSICIONES_FIN
            | TRANSICIONES error TRANSICIONES_FIN
           ;

transition_rules: DIGITO COMA CADENA_VACIA COMA DIGITO { transiciones.push_back(Transicion($1, '&', $5)); } transition_rules
                | DIGITO COMA LETRA COMA DIGITO { transiciones.push_back(Transicion($1, $3[0], $5)); } transition_rules
                | /* empty */
    ;

%%

std::set<int> estados;
std::set<char> alfabeto;
std::vector<Transicion> transiciones; // Donde Transicion es una estructura o clase que representa una transición
int estadoInicial;
std::set<int> estadosFinales;

void validarafn(){
    // Comprobar las transiciones
    for (const auto& transicion : transiciones) {
        if (estados.find(transicion.estadoOrigen) == estados.end()) {
            std::cerr << "Error: El estado origen " << transicion.estadoOrigen << " no existe.\n";
            exit(1);
        }
        if (estados.find(transicion.estadoDestino) == estados.end()) {
            std::cerr << "Error: El estado destino " << transicion.estadoDestino << " no existe.\n";
            exit(1);
        }
        if (alfabeto.find(transicion.simbolo) == alfabeto.end()) {
            std::cerr << "Error: El simbolo " << transicion.simbolo << " no existe en el alfabeto.\n";
            exit(1);
        }
    }

    // Comprobar el estado inicial
    if (estados.find(estadoInicial) == estados.end()) {
        std::cerr << "Error: El estado inicial " << estadoInicial << " no existe.\n";
        exit(1);
    }

    // Comprobar los estados finales
    for (const auto& estadoFinal : estadosFinales) {
        if (estados.find(estadoFinal) == estados.end()) {
            std::cerr << "Error: El estado final " << estadoFinal << " no existe.\n";
            exit(1);
        }
    }
}