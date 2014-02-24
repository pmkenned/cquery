#ifndef INSTANTIATION_H
#define INSTANTIATION_H

#include <iostream>

class Module; // contains Module* member

using namespace std;

class Instantiation {

    private:
        string name;
        Module * module_type;
        Instantiation * parent;
        list<Instantiation> insts;

    public:
        // constructors
        Instantiation() { }
        Instantiation(Module * mt, Instantiation * p, string n = "") : 
            module_type(mt), parent(p), name(n)
            { }

        // accessors
        const string& get_name () const { return name; }
        Instantiation& get_parent() { return *parent; }
        Module& get_module() { return *module_type; }

        void add_inst(Instantiation inst) {
            insts.push_back(inst);
        }

        void print_hierarchy(int n=1) {

            list<Instantiation>::iterator i;
            for(i = insts.begin(); i != insts.end(); i++ ) {
                for(int j=0; j<n; j++)
                    cout << "  ";
                cout << i->get_name() << endl;
                i->print_hierarchy(n+1);
            }
        }
};

#endif // INSTANTIATION_H
