#include "Tree.hpp"

Tree::Tree(int n, const vector<pair<int, int>>& mst) : n(n), mst(mst) {
    treeNodes.reserve(n);
    for (int i = 0; i < n; ++i) {
        treeNodes.emplace_back(i);
    }

    for (const auto& edge : mst) {
        int u = edge.first;
        int v = edge.second;
        treeNodes[u].add_child(&treeNodes[v]);
        treeNodes[v].add_child(&treeNodes[u]);
    }
    root = &treeNodes[0];
}

vector<TreeNode>& Tree::get_nodes() {
    return treeNodes;
}

TreeNode* Tree::get_root() const {
    return root;
}

Tree* Tree::buildTreeFromMST(const vector<pair<int, int>>& mst, int n) {
    return new Tree(n, mst);
}

int Tree::determineOrder(TreeNode* node, TreeNode* parent, int result) {
    node->change_status();
    int subtree_size = 0;


    bool has_non_parent_child = false;
    for (TreeNode* child : node->get_children()) {
        if (child != parent) {
            has_non_parent_child = true;
            break;
        }
    }

    if (node->get_children().empty() || !has_non_parent_child) {
        node->set_order(result + 1);
        return result + 1;
    }

    for (TreeNode* child : node->get_children()) {
        if (!child->get_status()) {
            int child_result = determineOrder(child, node, result);
            subtree_size = max(subtree_size, child_result);
        }
    }

    node->set_order(subtree_size + 1);
    return subtree_size + 1;
}

void Tree::runExperiment(int nMin, int nMax, int step, int rep, const std::string& filename) {
    std::ofstream file(filename);
    if (!file.is_open()) {
        std::cerr << "Nie można otworzyć pliku do zapisu wyników." << std::endl;
        return;
    }

    file << "n,AverageRounds,MaxRounds,MinRounds\n";

    for (int n = nMin; n <= nMax; n += step) {
        std::vector<int> totalRounds;

        for (int r = 0; r < rep; ++r) {
            Graph graph(n);
            vector<pair<int, int>> mst = graph.primMST();
            Tree tree(n, mst);
            srand(static_cast<unsigned int>(time(nullptr)));
            int random_node = rand() % n;
            vector<TreeNode>& nodes = tree.get_nodes();
            tree.determineOrder(&nodes[random_node], nullptr, 0);
            vector<int> rounds;
            for (TreeNode& node : nodes) {
                rounds.push_back(node.get_order());
            }
            totalRounds.push_back(*max_element(rounds.begin(), rounds.end()));
        }

        double avgRounds = accumulate(totalRounds.begin(), totalRounds.end(), 0.0) / rep;
        int maxRounds = *max_element(totalRounds.begin(), totalRounds.end());
        int minRounds = *min_element(totalRounds.begin(), totalRounds.end());

        file << n << "," << avgRounds << "," << maxRounds << "," << minRounds << "\n";
    }

    file.close();
}