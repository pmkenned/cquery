#ifndef SIGNAL_H
#define SIGNAL_H

#include <iostream>

namespace rtlp {

using std::string;

class Driver; // contains Driver member

class Signal {

    private:
        string name;
        int width;
        Driver * driver;

    public:

        Signal(string const& n, int w, Driver * d = 0) : name(n), width(w), driver(d) {}

        Driver& get_driver() {
            return *driver;
        }
};

} // namespace rtlp

#endif // SIGNAL_H
