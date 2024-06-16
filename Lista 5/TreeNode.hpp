#ifndef TREENODE_H
#define TREENODE_H

#include <vector>
#include <cstdlib>
#include <iostream>

using namespace std;

class TreeNode {
public:
    TreeNode(int id);
    int get_id() const;
    void add_child(TreeNode* child);
    void change_status();
    void show_status();
    bool get_status();
    void set_order(int order);
    int get_order();
    vector<TreeNode*>& get_children();
    const vector<TreeNode*>& get_children() const;

private:
    bool is_visited;
    int transmission_order;
    int id;
    vector<TreeNode*> children;
};

#endif // TREENODE_H
