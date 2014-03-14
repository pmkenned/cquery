#include <iostream>
#include <utility>
#include <algorithm>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/graphviz.hpp>

using namespace boost;

int main(int argc, char * argv[]) {

    typedef adjacency_list<vecS, vecS, bidirectionalS> Graph;

    Graph g(0);

    add_vertex(g);
    add_vertex(g);
    add_vertex(g);

    add_edge(0,1,g);
    add_edge(0,2,g);
    add_edge(1,2,g);

    write_graphviz(std::cout, g);

    return 0;
}
