#ifndef SIGNAL_H
#define SIGNAL_H

#include <iostream>

class Driver; // contains Driver member

using namespace std;

class Signal {

    private:
        string name;
        Driver * d;

    public:

        Signal(string n) : name(n) {}
        Signal(Driver & dd) : d(d) { }

        Driver& get_driver() {
            return *d;
        }
};


#endif // SIGNAL_H
