#ifndef DRIVER_H
#define DRIVER_H

#include <iostream>

using namespace std;

class Driver {

    private:
        int line_number;
    public:

        Driver(int ll = 0) {
            line_number = ll;
            cout << "driver constructor" << endl;
        }

        int get_line_number() {
            return line_number;
        }
};


#endif // DRIVER_H
