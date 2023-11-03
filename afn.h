// afn.h

#ifndef AFN_H
#define AFN_H

#include <set>
#include <vector>

// Supongamos que tienes estas estructuras de datos:
// Define the Transicion class or struct
// En tu archivo de encabezado (afn.h)

class Transicion {
public:
    int estadoOrigen;
    char simbolo;
    int estadoDestino;

    Transicion(int origen, char simbolo, int destino)
        : estadoOrigen(origen), simbolo(simbolo), estadoDestino(destino) {}
};

extern std::set<int> estados;
extern std::set<char> alfabeto;
extern std::vector<Transicion> transiciones; // Donde Transicion es una estructura o clase que representa una transición
extern int estadoInicial;
extern std::set<int> estadosFinales;

void validarafn();

#endif // AFN_H