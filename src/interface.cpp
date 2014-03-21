#include <iostream>
#include <list>
#include <string>
#include <utility>
#include <cstdio>
#include <cstring>

typedef std::list <std::pair<std::string,std::string> > ObjectList;
ObjectList objects;

class F {
    private:
        int x;
    public:
        F(const char * name) {
            std::string class_name("F");
            std::string object_name(name);
            std::pair<std::string, std::string> x(class_name, object_name);
            objects.push_back(x);
        }

        void set_x(int x) { this->x = x; }
        void inc_x() { x++; }
        int get_x() { return x; }
};

int main()
{
    F f("f");

    char buffer[100];

    std::fgets(buffer, 100, stdin);
    int l = std::strlen(buffer);
    buffer[l-1] = '\0'; // discard newline

    ObjectList::iterator it;
    for(it = objects.begin(); it != objects.end(); it++) {
        if(strcmp(buffer, it->second.c_str()) == 0) {
            std::cout << it->first << std::endl;
        }
    }

}
