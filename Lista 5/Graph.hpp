#ifndef GRAPH_H
#define GRAPH_H

#include <iostream>
#include <vector>
#include "Node.hpp"

using namespace std;

class Graph {
public:
    Graph(int n);

    int get_n() const;
    void set_n(int new_n);

    vector<Node>& get_nodes();

    void generateCompleteGraph();
    vector<pair<int, int>> primMST();
    void primMSTv2();
    void kruskalMST(vector<pair<double, pair<int, int>>> edges);
    void kruskalMSTv2();
    static void runExperiment(int nMin, int nMax, int step, int rep, const string& filename);


private:
    int n;
    vector<Node> nodes;
    int findParent(int i, vector<int>& parent);
    void unionSets(int u, int v, vector<int>& parent, vector<int>& rank);
};

#endif // GRAPH_H
