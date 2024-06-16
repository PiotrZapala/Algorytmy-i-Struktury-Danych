#include "Graph.hpp"
#include "Tree.hpp"

int presentation1() {
    int n;
    cout << "Podaj liczbe wierzcholkow grafu: ";
    cin >> n;
    cout << endl;

    if (n <= 0) {
        cout << "Liczba wierzchołków musi być dodatnia." << endl;
        return 1;
    }

    Graph graph(n);

    for (const Node& node : graph.get_nodes()) {
        cout << "Wierzcholek " << node.get_id() << " ma sąsiadów: ";
        for (const auto& neighbor : node.get_neighbors()) {
            cout << "(" << neighbor.first->get_id() << ", " << neighbor.second << ") ";
        }
        cout << endl;
    }
    cout << endl;
    
    graph.primMSTv2();
    graph.kruskalMSTv2();

    return 0;
}

int presentation2() {
    int n;
    cout << "Podaj liczbe wierzcholkow grafu: ";
    cin >> n;
    cout << endl;

    if (n <= 0) {
        cout << "Liczba wierzchołków musi być dodatnia." << endl;
        return 1;
    }  

    Graph graph(n);  

    vector<pair<int, int>> mst = graph.primMST();
    Tree tree(n, mst);
    for (const TreeNode& node : tree.get_nodes()) {
        cout << "Wierzcholek " << node.get_id() << " ma sąsiadów: ";
        for (const auto& children : node.get_children()) {
            cout << "(" << children->get_id() << ") ";
        }
        cout << endl;
    }
    cout << endl;
    srand(static_cast<unsigned int>(time(nullptr)));
    int random_node = rand() % n;
    vector<TreeNode>& nodes = tree.get_nodes();
    cout << "Wierzchołek początkowy: " << random_node << endl;
    cout << endl;
    tree.determineOrder(&nodes[random_node], nullptr, 0);
    for (TreeNode& node : nodes) {
        cout << "Wierzcholek " << node.get_id() << " ma kolejność: " << node.get_order() << endl;
    }

    return 0;
}

void test1() {
    int nMin = 100;
    int nMax = 10000;
    int step = 100;
    int rep = 10;

    Graph::runExperiment(nMin, nMax, step, rep, "results1.csv");
}

void test2() {
    int nMin = 100;
    int nMax = 1000;
    int step = 10;
    int rep = 10;

    Tree::runExperiment(nMin, nMax, step, rep, "results2.csv");
}

int main() {
    presentation1();
    presentation2();
    //test1();
    //test2();
    return 0;
}