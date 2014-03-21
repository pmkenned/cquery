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
typedef std::pair<string, string> Port;
typedef std::list<Port> PortMap;

class Instantiation {

    private:
        string name;
        Module * module_type;
        Instantiation * parent;
        std::list<Instantiation> insts;
        PortMap pm;

    public:
        // constructors
        Instantiation() { }
        Instantiation(Module * mt, Instantiation * p, string n = "", PortMap pm_arg = PortMap()) : 
            module_type(mt), parent(p), name(n), pm(pm_arg)
            { }

        // accessors
        string const & get_name () const { return name; }
        Instantiation const & get_parent() const { return *parent; }
        Module const & get_module() const { return *module_type; }

        void add_inst(Instantiation inst) {
            insts.push_back(inst);
        }

        void print_hierarchy(int n=0) {
            std::list<Instantiation>::iterator i;
            for(int j=0; j<n; j++)
                std::cout << "  ";
            std::cout << name << '(';
            PortMap::iterator j;
            for(j = pm.begin(); j != pm.end(); j++ ) {
                std::cout << j->first << ", ";
            }
            std::cout <<  ')' << std::endl;
            for(i = insts.begin(); i != insts.end(); i++ ) {
                i->print_hierarchy(n+1);
            }
        }
};

} // namespace rtlp

#endif // INSTANTIATION_H
