#ifndef ASSIGN_H
#define ASSIGN_H

#include <iostream>

#include "driver.h" // inherits from Driver

class Signal;

using namespace std;

class Assign : public Driver {

    private:
        Signal& signal;

    public:
        Assign(Signal& s) : signal(s) {}

};


#endif // ASSIGN_H
