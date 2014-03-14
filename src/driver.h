#ifndef DRIVER_H
#define DRIVER_H

#include <iostream>

namespace rtlp {

class Driver {

    private:
        int line_number;
    public:

        Driver(int ll = 0) {
            line_number = ll;
            std::cout << "driver constructor" << std::endl;
        }

        int get_line_number() {
            return line_number;
        }
};

} // namespace rtlp

#endif // DRIVER_H
