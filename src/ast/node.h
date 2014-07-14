#ifndef _NODE_H_
#define _NODE_H_

typedef struct node_tag {
    char * label;
    struct node_tag ** children;
    int num_children;
    int child_cap;
} node_t;

node_t * node(char * label, node_t * n1, node_t * n2);

extern node_t * ast;

#define YYSTYPE node_t *

#endif
