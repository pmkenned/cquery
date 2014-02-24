#ifndef MODULE_H
#define MODULE_H

#include <iostream>
#include "instantiation.h"

using namespace std;

class Module; // ToBeInst contains a Module&

struct ToBeInst {
    friend class Module;

    private:
        string name;
        Module& module_type;
    public:
        ToBeInst(Module& mt, string n = "") : module_type(mt), name(n)  {}
};

class Module {

    private:
        string name;
        list<ToBeInst> tbis;
        list<Signal> inputs;
        list<Signal> outputs;
        list<Signal> internal_sigs;
        list<Assign> assigns;

    public:
        //constructors
        Module(string n) : name(n) {}
        // accessors
        const string& get_name () const { return name; }

        void add_assign(string n) {
            // TODO: get the signal that has name n
            // maybe this should be done with a map
            // or maintain a sorted list and do a binary search
            Signal * s = new Signal(n);
            Assign * a = new Assign(*s);
            assigns.push_back(*a);
        }

        void add_signal(string n) {
            Signal * s = new Signal(n);
            internal_sigs.push_back(*s);
        }

        void add_input(Signal& s) {
            inputs.push_back(s);
        }

        void add_inst(Module& mt, string n) {
            ToBeInst * tbi = new ToBeInst(mt, n);
            tbis.push_back(*tbi);
        }

        Instantiation& instantiate(string n = "", Instantiation * parent = 0) {
            cout << "creating instantiation with name " << n << endl;

            Instantiation * inst = new Instantiation(this, parent, n);

            list<ToBeInst>::iterator i;
            for(i = tbis.begin(); i != tbis.end(); i++) {
                Module & i_m = i->module_type;
                string i_n = i->name;
                Instantiation & new_inst = i_m.instantiate(i_n, inst);
                inst->add_inst(new_inst);
            }

            return *inst;
        }
};

#endif // MODULE_H
