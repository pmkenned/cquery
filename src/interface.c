#include <stdio.h>
#include <string.h>
#include <malloc.h>

typedef char * byte_p;

typedef byte_p (*funcp)(byte_p, byte_p);

typedef struct {
    byte_p data;
    size_t size;
    size_t num;
} list_t;

byte_p map(funcp f, list_t * list) {
    int i, j;
    size_t size = list->size;
    size_t num = list->num;
    byte_p data = list->data;
    byte_p r = malloc(num*size);

    for(i=0; i<num; i++) {
        byte_p bp = f(r+i*size, data+i*size);
    }

    return r;
}



byte_p f(byte_p a, byte_p b) {
    printf("called f\n");
}

byte_p g(byte_p a, byte_p b) {
    printf("called g\n");
}

byte_p h(byte_p dest, byte_p elem) {
    int dist = 'a' - 'A';
    *dest = *elem+dist;
}

typedef byte_p (*sym_func)(byte_p, byte_p);

struct symbol_t {
    sym_func f;
    const char * name;
};

#define NUM_SYM     3

struct symbol_t symbols[] = {
    {f, "f"},
    {g, "g"},
    {(sym_func) map, "map"}
};

int chomp(char * s) {
    int n = 0;
    int l = strlen(s);
    char c = s[l-1];
    while(c == ' ' || c == '\n' || c== '\t') {
        s[l-1] = '\0';
        n++;
        l--;
        c = s[l-1];
    }
    return n;
}

int is_func(char * s) {
    int i;
    for(i=0; i<NUM_SYM; i++) {
        if(strcmp(s, symbols[i].name) == 0)
            return 1;
    }
    return 0;
}

int main() {

    char buffer[100];
    int i;

    fgets(buffer, 100, stdin);
    chomp(buffer);
    printf("buffer: '%s'\n",buffer);

    char * tokens[10];

    int t = 0;
    tokens[t++] = strtok(buffer, " \t");
    while(t < 10 && (tokens[t] = strtok(NULL, " \t")) != NULL) {
        t++;
    }

    for(i=0; i< t; i++) {
        printf("token[%d]: %s\n",i, tokens[i]);
    }

    for(i=0; i<t; i++) {
        if(is_func(tokens[i])) {
            printf("%s is a function\n",tokens[i]);
        }
    }

//    char x[] = {'A', 'B', 'C'};
//    list_t l = { .data = x, .size = sizeof(char), .num = 3 };
//    char * new = map(h, &l);

    return 0;
}
