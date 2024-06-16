#ifndef TREE_H
#define TREE_H

#include <vector>
#include <iostream>
#include <fstream>
#include <ctime>
#include <cstdlib>
#include <algorithm>
#include <numeric>
#include "TreeNode.hpp"
#include "Graph.hpp"

using namespace std;

class Tree {
public:
    Tree(int n, const vector<pair<int, int>>& mst);
    TreeNode* get_root() const;
    vector<TreeNode>& get_nodes();
    static Tree* buildTreeFromMST(const vector<pair<int, int>>& mst, int n);
    int determineOrder(TreeNode* node, TreeNode* parent, int result);
    static void runExperiment(int nMin, int nMax, int step, int rep, const std::string& filename); 

private:
    int n;
    vector<TreeNode> treeNodes;
    vector<pair<int, int>> mst;
    TreeNode* root;
};

#endif // TREE_H
