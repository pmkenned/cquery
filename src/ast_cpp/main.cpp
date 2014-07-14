#include <iostream>
#include <vector>
#include <cstdlib>
#include <cstdio>

#include "y.tab.h"
#include "node.h"

class Signal {
    private:
        std::string name;
        unsigned int width;
    public:
        void set_name(std::string const & s) { name = s; }
        std::string const & get_name() { return name; }
};

class Assign {
    private:
        Signal * s;
    public:
};


class Module; // ToBeInst contains a Module *

struct ToBeInst {
    friend class Module;

    private:
        std::string name;
        Module * module_type;
//        PortMap pm;
    public:
        void set_name(std::string const & n) { name = n; }
//        ToBeInst(Module& mt, string n = "") : module_type(mt), name(n)  {}

//        void add_port(Port p) {
//            pm.push_back(p);
//        }
};


class Module {
    private:
        std::string name;
        std::vector<Signal *> inputs;
        std::vector<Signal *> outputs;
        std::vector<Signal *> internal_signals;
        std::vector<ToBeInst *> tbis;
    public:
        void set_name(std::string const & n) { name = n; }
        std::string const & get_name() { return name; }
        void add_signal(Signal * s) { internal_signals.push_back(s); }
        void add_tbi(ToBeInst * tbi) { tbis.push_back(tbi); }
        void print_signals() { 
            for(std::vector<Signal *>::iterator i = internal_signals.begin(); i != internal_signals.end(); i++) {
                std::cout << (*i)->get_name() << std::endl;
            }
        }
};

class Design {
    private:
        std::vector<Module *> modules;
    public:
        void add_module(Module * m) {
            modules.push_back(m);
        }
        void print_modules() {
            for(std::vector<Module *>::iterator i = modules.begin(); i != modules.end(); i++) {
                std::cout << (*i)->get_name() << std::endl;
                (*i)->print_signals();
            }
        }
};

// node is signal_decl
Signal * ast_node_to_signal(node_t * ast_node) {

    Signal * s = new Signal;

    // child 0 is ident_list
    //  child 0 is signal name
    s->set_name(ast_node->children[0]->children[0]->label);

    return s;

}

ToBeInst * ast_node_to_tbi(node_t * ast_node) {
    ToBeInst * tbi = new ToBeInst;

    tbi->set_name(ast_node->children[0]->label);

    return tbi;
}

Module * ast_node_to_module(node_t * ast_node) {

    Module * m = new Module;

    m->set_name(ast_node->children[0]->label);

    // child 1 is signal_list
    for( std::vector<node_t *>::iterator i = ast_node->children[1]->children.begin();
         i != ast_node->children[1]->children.end();
         i++) {
        Signal * s = ast_node_to_signal(*i);
        m->add_signal(s);
    }

    // child 2 is list_of_assign_or_inst
    for( std::vector<node_t *>::iterator i = ast_node->children[2]->children.begin();
         i != ast_node->children[2]->children.end();
         i++) {
        if((*i)->label == "instantiation") {
            ToBeInst * tbi = ast_node_to_tbi(*i);
            m->add_tbi(tbi);
        }
        else if((*i)->label == "assign") {
            Assign * assign = ast_node_to_assign(*i);
            m->add_assign(assign);
        }
    }

    return m;

}

extern FILE * yyin;
node_t * ast;
Design * d;

void ast_to_design() {
    d = new Design;

    for(std::vector<node_t *>::iterator i = ast->children.begin();
        i != ast->children.end();
        i++) {
        if( (*i)->label == "arch_def") {
//            std::cout << (*i)->children[0]->label << std::endl;
            Module * m = ast_node_to_module(*i);
            d->add_module(m);
        }
    }

}

void interface() {
    d->print_modules();
}

int main(int argc, char * argv[]) {

    if(argc < 2) {
        std::cerr << "usage: " << argv[0] << " [file]\n";
        std::exit(1);
    }

    yyin = std::fopen(argv[1], "r");

    if(yyin == NULL) {
        std::cerr << "error: cannot read file " << argv[1] << std::endl;
        std::exit(1);
    }

    yyparse();

    ast_to_design();

    interface();

}
