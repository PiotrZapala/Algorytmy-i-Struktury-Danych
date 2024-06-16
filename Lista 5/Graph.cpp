#include <fstream>
#include <queue>
#include <stack>
#include <cstdlib>
#include <ctime>
#include "Graph.hpp"

Graph::Graph(int n) {
    this->n = n;
    generateCompleteGraph();
}

int Graph::get_n() const {
    return n;
}

void Graph::set_n(int new_n) {
    this->n = new_n;
    nodes.clear();
    generateCompleteGraph();
}

vector<Node>& Graph::get_nodes() {
    return nodes;
}

void Graph::generateCompleteGraph() {
    nodes.clear();
    srand(static_cast<unsigned int>(time(0)));

    for (int i = 0; i < n; ++i) {
        nodes.push_back(Node(i));
    }
    vector<vector<double>> weights(n, vector<double>(n, 0.0));

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            if (i != j) {
                double weight = static_cast<double>(rand()) / RAND_MAX;
                weights[i][j] = weight;
                weights[j][i] = weight;
            }
        }
    }

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            if (i != j) {
                nodes[i].add_neighbor(&nodes[j], weights[i][j]);
            }
        }
    }
}

vector<pair<int, int>> Graph::primMST() {
    priority_queue<pair<double, int>, vector<pair<double, int>>, greater<pair<double, int>>> pq;
    vector<double> minEdge(n, numeric_limits<double>::infinity());
    vector<bool> inMST(n, false);
    vector<int> parent(n, -1);
    vector<pair<int, int>> mst;

    minEdge[0] = 0.0;
    pq.push({0.0, 0});

    while (!pq.empty()) {
        int u = pq.top().second;
        pq.pop();

        if (inMST[u]) continue;
        inMST[u] = true;

        for (const auto& neighbor : nodes[u].get_neighbors()) {
            int v = neighbor.first->get_id();
            double weight = neighbor.second;

            if (!inMST[v] && weight < minEdge[v]) {
                minEdge[v] = weight;
                pq.push({minEdge[v], v});
                parent[v] = u;
            }
        }
    }

    for (int i = 1; i < n; ++i) {
        if (parent[i] != -1) {
            mst.push_back(make_pair(parent[i], i));
        }
    }
    return mst;
}

void Graph::primMSTv2() {
    priority_queue<pair<double, int>, vector<pair<double, int>>, greater<pair<double, int>>> pq;
    vector<double> minEdge(n, numeric_limits<double>::infinity());
    vector<bool> inMST(n, false);
    vector<int> parent(n, -1);
    vector<pair<int, int>> mst;

    minEdge[0] = 0.0;
    pq.push({0.0, 0});

    while (!pq.empty()) {
        int u = pq.top().second;
        pq.pop();

        if (inMST[u]) continue;
        inMST[u] = true;

        for (const auto& neighbor : nodes[u].get_neighbors()) {
            int v = neighbor.first->get_id();
            double weight = neighbor.second;

            if (!inMST[v] && weight < minEdge[v]) {
                minEdge[v] = weight;
                pq.push({minEdge[v], v});
                parent[v] = u;
            }
        }
    }

    for (int i = 1; i < n; ++i) {
        if (parent[i] != -1) {
            mst.push_back(make_pair(parent[i], i));
        }
    }

    double totalWeight = 0.0;
    cout << "Minimalne Drzewo Rozpinające (MST) - Prim:" << endl;
    for (const auto& edge : mst) {
        int u = edge.first;
        int v = edge.second;
        double weight = 0.0;

        for (const auto& neighbor : nodes[u].get_neighbors()) {
            if (neighbor.first->get_id() == v) {
                weight = neighbor.second;
                break;
            }
        }

        cout << "Krawędź (" << u << ", " << v << ") z wagą " << weight << endl;
        totalWeight += weight;
    }
    cout << "Całkowita waga MST (Prim): " << totalWeight << endl;
}

int Graph::findParent(int i, vector<int>& parent) {
    if (i == parent[i])
        return i;
    return parent[i] = findParent(parent[i], parent);
}

void Graph::unionSets(int u, int v, vector<int>& parent, vector<int>& rank) {
    u = findParent(u, parent);
    v = findParent(v, parent);

    if (rank[u] < rank[v]) {
        parent[u] = v;
    } else if (rank[u] > rank[v]) {
        parent[v] = u;
    } else {
        parent[v] = u;
        rank[u]++;
    }
}

void Graph::kruskalMST(vector<pair<double, pair<int, int>>> edges) {
    sort(edges.begin(), edges.end());

    vector<int> parent(n);
    vector<int> rank(n, 0);
    for (int i = 0; i < n; ++i)
        parent[i] = i;

    vector<pair<int, int>> mst;

    for (const auto& edge : edges) {
        int u = edge.second.first;
        int v = edge.second.second;

        if (findParent(u, parent) != findParent(v, parent)) {
            mst.push_back({u, v});
            unionSets(u, v, parent, rank);
        }
    }
}

void Graph::kruskalMSTv2() {
    vector<pair<double, pair<int, int>>> edges;
    for (int i = 0; i < n; ++i) {
        for (const auto& neighbor : nodes[i].get_neighbors()) {
            int u = i;
            int v = neighbor.first->get_id();
            double weight = neighbor.second;
            if (u < v) {
                edges.push_back({weight, {u, v}});
            }
        }
    }

    sort(edges.begin(), edges.end());

    vector<int> parent(n);
    vector<int> rank(n, 0);
    double totalWeight = 0;
    for (int i = 0; i < n; ++i)
        parent[i] = i;

    vector<pair<int, int>> mst;

    for (const auto& edge : edges) {
        double weight = edge.first;
        int u = edge.second.first;
        int v = edge.second.second;

        if (findParent(u, parent) != findParent(v, parent)) {
            mst.push_back({u, v});
            totalWeight += weight;
            unionSets(u, v, parent, rank);
        }
    }
    cout << "Minimalne Drzewo Rozpinające (MST) - Kruskal:" << endl;
    for (const auto& edge : mst) {
        int u = edge.first;
        int v = edge.second;
        double weight = 0.0;

        for (const auto& neighbor : nodes[u].get_neighbors()) {
            if (neighbor.first->get_id() == v) {
                weight = neighbor.second;
                break;
            }
        }

        cout << "Krawędź (" << u << ", " << v << ") z wagą " << weight << endl;
    }
    cout << "Całkowita waga MST (Kruskal): " << totalWeight << endl;
}

void Graph::runExperiment(int nMin, int nMax, int step, int rep, const string& filename) {
    ofstream file(filename);
    if (!file.is_open()) {
        cerr << "Nie można otworzyć pliku do zapisu wyników." << endl;
        return;
    }

    file << "n,PrimTime,KruskalTime\n";

    for (int n = nMin; n <= nMax; n += step) {
        double totalPrimTime = 0.0;
        double totalKruskalTime = 0.0;

        for (int r = 0; r < rep; ++r) {
            Graph graph(n);

            auto start = chrono::high_resolution_clock::now();
            graph.primMST();
            auto end = chrono::high_resolution_clock::now();
            chrono::duration<double> primDuration = end - start;
            totalPrimTime += primDuration.count();

            vector<pair<double, pair<int, int>>> edges;
            for (int i = 0; i < n; ++i) {
                for (const auto& neighbor : graph.nodes[i].get_neighbors()) {
                    int u = i;
                    int v = neighbor.first->get_id();
                    double weight = neighbor.second;
                    if (u < v) {
                        edges.push_back({weight, {u, v}});
                    }
                }
            }

            start = chrono::high_resolution_clock::now();
            graph.kruskalMST(edges);
            end = chrono::high_resolution_clock::now();
            chrono::duration<double> kruskalDuration = end - start;
            totalKruskalTime += kruskalDuration.count();
        }

        double avgPrimTime = totalPrimTime / rep;
        double avgKruskalTime = totalKruskalTime / rep;

        file << n << "," << avgPrimTime << "," << avgKruskalTime << "\n";
    }

    file.close();
}