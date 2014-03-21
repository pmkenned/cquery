#include <cstdlib>
#include <iostream>
#include <fstream>

#include "driver.h"
#include "assign.h"
#include "signal.h"
#include "module.h"
#include "instantiation.h"

using namespace std;
using namespace rtlp;

int main(int argc, char * argv[]) {

    Module Alpha("Alpha");
    Module Bravo("Bravo");
    Module Charlie("Charlie");

    Bravo.add_signal("x");

    Bravo.add_assign("x"); // TODO: expression argument

    Bravo.add_inst(Charlie, "c0");

    ToBeInst * b0_tbi = Alpha.add_inst(Bravo, "b0");
    Port p0("x", "a");
    b0_tbi->add_port(p0);

    ToBeInst * b1_tbi = Alpha.add_inst(Bravo, "b1");
    Port p1("x", "b");
    b0_tbi->add_port(p1);

    Instantiation a = Alpha.instantiate();

    a.print_hierarchy();

}
