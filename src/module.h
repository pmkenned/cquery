#ifndef MODULE_H
#define MODULE_H

#include <iostream>
#include <list>
#include "instantiation.h"
#include "signal.h"
#include "assign.h"

namespace rtlp {

using std::string;

class Module; // ToBeInst contains a Module&

struct ToBeInst {
    friend class Module;

    private:
        string name;
        Module& module_type;
        PortMap pm;
    public:
        ToBeInst(Module& mt, string n = "") : module_type(mt), name(n)  {}

        void add_port(Port p) {
            pm.push_back(p);
        }
};

class Module {

    private:
        string name;
        std::list<ToBeInst> tbis;
        std::list<Signal> inputs;
        std::list<Signal> outputs;
        std::list<Signal> internal_sigs;
        std::list<Assign> assigns;

    public:
        // constructors
        Module(string n) : name(n) {}
        // accessors
        const string& get_name () const { return name; }

        void add_assign(string n) {
            // TODO: get the signal that has name n
            // maybe this should be done with a map
            // or maintain a sorted list and do a binary search
            Signal * s = new Signal(n,1);
            Assign * a = new Assign(*s);
            assigns.push_back(*a);
        }

        void add_signal(string n) {
            Signal * s = new Signal(n,1);
            internal_sigs.push_back(*s);
        }

        void add_input(Signal& s) {
            inputs.push_back(s);
        }

        ToBeInst * add_inst(Module& mt, string n) {
            ToBeInst * tbi = new ToBeInst(mt, n);
            tbis.push_back(*tbi);
            return tbi;
        }

        Instantiation& instantiate(string n = "", Instantiation * parent = 0, PortMap pm = PortMap()) {
            if(n == "")
                n = name;
            std::cout << "creating instantiation with name " << n << std::endl;

            Instantiation * inst = new Instantiation(this, parent, n, pm);

            std::list<ToBeInst>::iterator i;
            for(i = tbis.begin(); i != tbis.end(); i++) {
                Module & i_m = i->module_type;
                string i_n = i->name;
                PortMap i_pm = i->pm;
                Instantiation & new_inst = i_m.instantiate(i_n, inst, i_pm);
                inst->add_inst(new_inst);
            }

            return *inst;
        }
};

} // namespace rtlp

#endif // MODULE_H
