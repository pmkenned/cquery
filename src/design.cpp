#include <iostream>
#include <list>

#include "module.h"


namespace rtlp {

class Design {
    private:
        std::list<Module> modules;
    public:
        void add_module(std::string s) {
            Module * m = new Module(s);
            modules.push_back(*m);
        }
};

class AST {
    private:
    public:
};

Design * ast_to_design(AST const & ast) {
    // invokes ast_node_to_module for each module node
}

Module * ast_node_to_module() {
    // invokes ast_node_to_assign for each assign node
    // invokes ast_node_to_signal for each signal node
    // invokes ast_node_to_tbi for each ToBeInst node
}

Assign * ast_node_to_assign() {
    Assign * assign = new Assign;
    // invokes ast_node_to_expr for the expression node
}

Expr * ast_node_to_expr() {}

Signal * ast_node_to_signal() {}

ToBeInst * ast_node_to_tbi() {}



}

using namespace rtlp;

int main() {
    AST ast;

    Design * d = ast_to_design(ast);

}
