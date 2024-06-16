#ifndef NODE_H
#define NODE_H

#include <vector>
#include <utility>

using namespace std;

class Node {
public:
    Node(int id);

    int get_id() const;
    void set_id(int new_id);

    char get_color() const;
    void set_color(char new_color);

    void add_neighbor(Node* neighbor, double weight);
    
    vector<pair<Node*, double>>& get_neighbors();
    const vector<pair<Node*, double>>& get_neighbors() const;

private:
    int id;
    char color;
    vector<pair<Node*, double>> neighbors;
};

#endif // NODE_H
