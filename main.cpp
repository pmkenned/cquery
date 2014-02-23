#include <iostream>
#include <fstream>
#include <cstdlib>

#include <list>

using namespace std;

class Driver;
class Assign;
class Signal;
class Module;
class Instantiation;

class Assign : public Driver {


};

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

class Signal {

    private:
        Driver * d;

    public:

        Signal(Driver & dd) : d(d) {
            cout << "signal constructor" << endl;
        }


       Driver& get_driver() {
            return *d;
        }


};

class Instantiation {

    private:

        string name;
        Module * module_type;
        Instantiation * parent;

    public:

        Instantiation(Module * mt) : module_type(mt) {
        }

        Instantiation& get_parent() {
            return *parent;
        }

        Module& get_module() {
            return *module_type;
        }

};

class Module {

    private:

        string name;
        list<Instantiation> insts;
        list<Signal> iolist;
        list<Signal> internal_sigs;
        list<Assign> assigns;

    public:

        Module(string n) : name(n) {
        }

        const string& get_name () const {
            return name;
        }

        Instantiation & instantiate() {
            Instantiation * inst = new Instantiation(this);
            return *inst;
        }

        void add_inst(Instantiation inst) {
            insts.push_back(inst);
        }

};


int main(int argc, char * argv[]) {


    Module foo("foo");
    Module bar("bar");

    cout << foo.get_name() << endl;

    Instantiation f = foo.instantiate();

    Module & f_m = f.get_module();
    cout << f_m.get_name() << endl;

    Instantiation b = bar.instantiate();

    foo.add_inst(b);

}
