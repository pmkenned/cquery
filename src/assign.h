#ifndef ASSIGN_H
#define ASSIGN_H

#include <iostream>

#include "driver.h" // inherits from Driver

namespace rtlp {

class Signal;

class Assign : public Driver {

    private:
        Signal * signal;

    public:
        Assign(Signal & s) : signal(&s) {}

};

} // namespace rtlp

#endif // ASSIGN_H
