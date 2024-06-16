#include "TreeNode.hpp"

TreeNode::TreeNode(int id) : id(id) {}

int TreeNode::get_id() const {
    return id;
}

void TreeNode::add_child(TreeNode* child) {
    children.push_back(child);
}

void TreeNode::change_status() {
    is_visited = true;
}

void TreeNode::show_status() {
    cout << is_visited;
}

bool TreeNode::get_status() {
    return is_visited;
}

void TreeNode::set_order(int order) {
    transmission_order = order;
}

int TreeNode::get_order() {
    return transmission_order;
}

vector<TreeNode*>& TreeNode::get_children() {
    return children;
}

const vector<TreeNode*>& TreeNode::get_children() const {
    return children;
}
