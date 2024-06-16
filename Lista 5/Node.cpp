#include "Node.hpp"

Node::Node(int id) {
    this->id = id;
    this->color = 'W';
}

int Node::get_id() const {
    return id;
}

void Node::set_id(int new_id) {
    this->id = new_id;
}

vector<pair<Node*, double>>& Node::get_neighbors() {
    return neighbors;
}

const vector<pair<Node*, double>>& Node::get_neighbors() const {
    return neighbors;
}

void Node::add_neighbor(Node* neighbor, double weight) {
    this->neighbors.push_back(make_pair(neighbor, weight));
}

void Node::set_color(char new_color) {
    this->color = new_color;
}

char Node::get_color() const {
    return color;
}
