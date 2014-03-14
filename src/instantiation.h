#ifndef INSTANTIATION_H
#define INSTANTIATION_H

#include <iostream>
#include <list>
#include <utility>

namespace rtlp {

using std::string;

class Module; // contains Module* member

// TODO: int should be expression
// should string actually be signal? we may only need the name
typedef std::list<std::pair<string, int> > PortMap;

class Instantiation {

    private:
        string name;
        Module * module_type;
        Instantiation * parent;
        std::list<Instantiation> insts;
        PortMap p;

    public:
        // constructors
        Instantiation() { }
        Instantiation(Module * mt, Instantiation * p, string n = "") : 
            module_type(mt), parent(p), name(n)
            { }

        // accessors
        string const & get_name () const { return name; }
        Instantiation const & get_parent() const { return *parent; }
        Module const & get_module() const { return *module_type; }

        void add_inst(Instantiation inst) {
            insts.push_back(inst);
        }

        void print_hierarchy(int n=1) {

            std::list<Instantiation>::iterator i;
            for(i = insts.begin(); i != insts.end(); i++ ) {
                for(int j=0; j<n; j++)
                    std::cout << "  ";
                std::cout << i->get_name() << std::endl;
                i->print_hierarchy(n+1);
            }
        }
};

} // namespace rtlp

#endif // INSTANTIATION_H
