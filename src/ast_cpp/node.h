#ifndef _NODE_H_
#define _NODE_H_

#include <vector>
#include <string>

struct node_t {
    std::string label;
    std::vector<node_t *> children;
};

node_t * node(std::string const & label, node_t * n1, node_t * n2);

extern node_t * ast;

#define YYSTYPE node_t *

#endif
