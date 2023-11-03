#include <iostream>
#include <string>
#include <fstream>
#include <cstdlib>
#include <set>
#include <vector>
#include <map>
#include "lex.yy.c"
#include "analizador.tab.c"
#include "analizador.tab.h"
#include "afn.h"

extern FILE* yyin;

extern char* yytext;
extern int yylineno;
extern int yylex();
extern int yyparse();

extern void yyerror(const char *s);

bool seEncontroError = false;

void yyerror(const char *s) {
    seEncontroError = true;
    std::ofstream errorFile("bitacoraErrores.txt", std::ios_base::app);
    errorFile << "Error en la linea " << yylineno << ": " << s << ", token erroneo: " << yytext << std::endl;
    errorFile.close();
}

void generarGrafo() {
    std::ofstream dotFile("afn.dot");

    dotFile << "digraph AFN {\n";
    dotFile << "    rankdir=LR;\n";  // Agrega esta línea

    // Define los estados (nodos)
    for (const auto& estado : estados) {
        if (estadosFinales.count(estado) > 0) {
            // Si el estado es un estado final, usa un círculo doble
            dotFile << "    " << estado << " [shape=doublecircle];\n";
        } else {
            // Si no, usa un círculo normal
            dotFile << "    " << estado << " [shape=circle];\n";
        }
    }

    // Define las transiciones (aristas)
    for (const auto& transicion : transiciones) {
        dotFile << "    " << transicion.estadoOrigen << " -> " << transicion.estadoDestino << " [label=\"" << transicion.simbolo << "\"];\n";
    }

    dotFile << "}\n";

    dotFile.close();

    // Genera el gráfico con Graphviz
    system("dot -Tpng afn.dot -o afn.png");
}

void eliminarArchivoSiExiste(const char* fileName) {
    FILE* file = fopen(fileName, "r");
    if (file != nullptr) {
        fclose(file);
        if (std::remove(fileName) != 0) {
            std::cerr << "No se pudo eliminar el archivo: " << fileName << std::endl;
        }
    }
}

extern void validarafn(); 

extern std::set<int> estados;
extern std::set<char> alfabeto;
extern std::vector<Transicion> transiciones; // Donde Transicion es una estructura o clase que representa una transición
extern int estadoInicial;
extern std::set<int> estadosFinales;


int main() {
    eliminarArchivoSiExiste("bitacoraErrores.txt");

    int option;

    while (true) {
        system("cls");
        std::cout << "******** Menu: ********" << std::endl;
        std::cout << "\n1. Ingresar archivo" << std::endl;
        std::cout << "2. Cerrar programa" << std::endl;
        std::cout << "\nSeleccione una opcion: ";
        std::cin >> option;
        system("cls");

        if (option == 1) {
            std::string fileName;
            std::cout << "Ingrese el nombre del archivo: ";
            std::cin >> fileName;

            if (fileName.length() >= 5 && fileName.substr(fileName.length() - 4) == ".xml") {
                // El archivo tiene la extensión ".html"
                yyin = fopen(fileName.c_str(), "r");
                if (!yyin) {
                    std::cerr << "Error al abrir el archivo: " << fileName << std::endl;
                    continue;
                }
            
                // Realizar el análisis sintáctico
                int result = yyparse();

                // Comprobar si hay errores
                validarafn();

                if (result == 0 && !seEncontroError) {
                    std::cout << "Analisis completado con exito." << std::endl;
                    system("pause");
                    system("cls");

                    //Representacion interna del AFN
                    std::map<int, std::map<char, std::set<int>>> tablaTransiciones;
                    for (const auto& transicion : transiciones) {
                        tablaTransiciones[transicion.estadoOrigen][transicion.simbolo].insert(transicion.estadoDestino);
                    }   

                    // Mostrar el menú del AFN
                    while (true) {
                        std::cout << "************* Menu del AFN: *************\n";
                        std::cout << "\n1. Estados del AFN\n";
                        std::cout << "2. Alfabeto del AFN1\n";
                        std::cout << "3. Estados finales de aceptacion del AFN\n";
                        std::cout << "4. Tabla de transiciones del AFN\n";
                        std::cout << "5. Grafo dirigido del AFN\n";
                        std::cout << "6. Regresar al menu principal\n";
                        std::cout << "\nSeleccione una opcion: ";
                        int opcionAFN;
                        std::cin >> opcionAFN;

                        switch (opcionAFN) {
                            case 1:
                                // Mostrar los estados del AFN
                                system("cls");
                                std::cout << "Estados del AFN:\n";
                                for (const auto& estado : estados) {
                                    std::cout << estado << " "<< std::endl;
                                }
                                std::cout << "\n";
                                system("pause");
                                system("cls");
                                break;
                            case 2:
                                // Mostrar el alfabeto del AFN
                                system("cls");
                                std::cout << "Alfabeto del AFN:\n";
                                for (const auto& simbolo : alfabeto) {
                                    std::cout << simbolo << " " << std::endl;
                                }
                                std::cout << "\n";
                                system("pause");
                                system("cls");
                                break;
                            case 3:
                                // Mostrar los estados finales de aceptación del AFN
                                system("cls");
                                std::cout << "Estados finales de aceptacion del AFN:\n";
                                for (const auto& estadoFinal : estadosFinales) {
                                    std::cout << estadoFinal << " " << std::endl;
                                }
                                std::cout << "\n";
                                system("pause");
                                system("cls");
                                break;
                            case 4:
                                // Mostrar la tabla de transiciones del AFN
                                system("cls");
                                std::cout << "Tabla de transiciones del AFN:\n";
                                for (const auto& transicion : transiciones) {
                                    std::cout << "De estado | " << transicion.estadoOrigen << " | a estado | " << transicion.estadoDestino << " | con simbolo | " << transicion.simbolo << "\n";
                                }
                                std::cout << "\n";
                                system("pause");
                                system("cls");
                                break;
                            case 5:
                                // Mostrar el grafo dirigido del AFN
                                system("cls");
                                generarGrafo();
                                std::cout << "Grafo dirigido del AFN generado con exito." << std::endl;
                                system("pause");
                                system("start afn.png");
                                system("cls");
                                break;
                            case 6:
                                // Regresar al menú principal
                                goto main_menu;
                            default:
                                std::cout << "Opcion no valida. Por favor, seleccione una opcion del 1 al 6.\n";
                        }
                    }
                
                } else {
                    std::cout << "Se encontraron errores durante el analisis." << std::endl;
                    system("pause");
                    system("start bitacoraErrores.txt");
                    break;
                }
            
                fclose(yyin);
            } else {
                std::cerr << "El archivo debe tener la extension .xml" << std::endl;
                system("pause");
                break;
            }
            main_menu:;    
        } else if (option == 2) {
            std::cout << "Cerrando el programa." << std::endl;
            break;
        } else {
            std::cerr << "Opcion no valida. Seleccione 1 para ingresar archivo o 2 para cerrar el programa." << std::endl;
        }
    }

    return 0;
}
