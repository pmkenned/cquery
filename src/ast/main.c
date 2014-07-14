#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "node.h"

extern FILE * yyin;

#define BUF_SIZE 1000

node_t * ast;

void chomp(char * s) {

    int l = strlen(s);
    if(l == 0)
        return;

    while(s[l-1] == '\n' || s[l-1] == ' ' || s[l-1] == '\t') {
        s[l-1] = '\0';
        l--;
    }
}

void interface() {

    char buffer[BUF_SIZE];
    int i;
    
    char prompt[] = "> ";

    printf("%s",prompt);

    while(fgets(buffer, BUF_SIZE, stdin) != NULL) {
        chomp(buffer);

        if(strcmp(buffer, "quit") == 0)
            break;

        if(strcmp(buffer, "la") == 0) {

            int num_children = ast->num_children;
            for(i=0; i < num_children; i++) {
                if(strcmp(ast->children[i]->label, "arch_def") == 0) {
                    printf("%s\n", ast->children[i]->children[0]->label);
                }
            }
            
        }
        printf("%s",prompt);
    }
}


int main(int argc, char * argv[])
{
    if(argc < 2) {
        fprintf(stderr, "usage: %s [file]\n", argv[0]);
        exit(1);
    }

    yyin = fopen(argv[1], "r");

    if(yyin == NULL) {
        fprintf(stderr,"error: cannot read file %s\n", argv[1]);
        exit(1);
    }

    yyparse();

//    interface();

    return 0;
}
