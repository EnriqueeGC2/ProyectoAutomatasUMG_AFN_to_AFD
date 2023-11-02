#include <iostream>
#include <string>
#include <fstream>
#include "lex.yy.c"
#include "analizador.tab.c"
#include "analizador.tab.h"

extern char* yytext;
extern int yylineno;
extern int yylex();
extern int yyparse();

extern FILE* yyin;
extern std::ofstream outFile;

extern void yyerror(const char *s);

int main() {
    int option;

    while (true) {
        std::cout << "Menu:" << std::endl;
        std::cout << "1. Ingresar archivo" << std::endl;
        std::cout << "2. Cerrar programa" << std::endl;
        std::cout << "Seleccione una opcion: ";
        std::cin >> option;

        if (option == 1) {
            std::string fileName;
            std::cout << "Ingrese el nombre del archivo: ";
            std::cin >> fileName;

            yyin = fopen(fileName.c_str(), "r");
            if (!yyin) {
                std::cerr << "Error al abrir el archivo: " << fileName << std::endl;
                continue;
            }

            // Abrir el archivo de salida
            outFile.open("output.txt");
            if (!outFile) {
                std::cerr << "No se pudo abrir el archivo de salida." << std::endl;
                fclose(yyin);
                return 1;
            }

            // Realizar el análisis sintáctico
            int result = yyparse();

            // Cerrar el archivo de salida
            outFile.close();

            if (result == 0) {
                std::cout << "Analisis completado con exito." << std::endl;
            } else {
                std::cout << "Se encontraron errores durante el análisis." << std::endl;
            }
            
            fclose(yyin);
        } else if (option == 2) {
            std::cout << "Cerrando el programa." << std::endl;
            break;
        } else {
            std::cerr << "Opcion no valida. Seleccione 1 para ingresar archivo o 2 para cerrar el programa." << std::endl;
        }
    }

    return 0;
}