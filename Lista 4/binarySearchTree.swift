import Foundation

class Node {
    var left: Node?
    var right: Node?
    var data: Int

    init(_ key: Int) {
        self.left = nil
        self.right = nil
        self.data = key
    }
}

class BinarySearchTree {
    var root: Node?

    func insertNode(_ root: Node?, _ key: Int) {
        let node = Node(key)
        if let root = root {
            if root.data < node.data {
                if root.right == nil {
                    root.right = node
                } else {
                    insertNode(root.right, node.data)
                }
            } else {
                if root.left == nil {
                    root.left = node
                } else {
                    insertNode(root.left, node.data)
                }
            }
        } else {
            self.root = node
        }
    }

    func searchNode(_ root: Node?, _ key: Int) -> Node? {
        if let root = root {
            if root.data == key {
                print("Key found")
                return root
            } else if root.data < key {
                return searchNode(root.right, key)
            } else {
                return searchNode(root.left, key)
            }
        } else {
            print("Key not found")
            return nil
        }
    }

    func deleteNode(_ root: Node?, _ key: Int) -> Node? {
        guard let root = root else {
            return nil
        }

        if key < root.data {
            root.left = deleteNode(root.left, key)
        } else if key > root.data {
            root.right = deleteNode(root.right, key)
        } else {
            if root.left == nil {
                return root.right
            } else if root.right == nil {
                return root.left
            }

            if let temp = findMin(root.right) {
                root.data = temp
                root.right = deleteNode(root.right, temp)
            }
        }
        return root
    }

    func findMin(_ node: Node?) -> Int? {
        var current = node
        while let left = current?.left {
            current = left
        }
        return current?.data
    }
    
    func findMax(_ node: Node?) -> Node? {
        var current = node
        while let right = current?.right {
            current = right
        }
        return current
    }

    func deleteMin(_ node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        
        if node.left == nil {
            return node.right
        }
        
        node.left = deleteMin(node.left)
        return node
    }
    
    func deleteMax(_ node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        
        if node.right == nil {
            return node.left
        }
        
        node.right = deleteMax(node.right)
        return node
    }

    func inOrder(_ node: Node?) {
        guard let node = node else {
            return
        }
        
        inOrder(node.left)
        print("\(node.data)", terminator: " ")
        inOrder(node.right)
    }
    
    func postOrder(_ node: Node?) {
        guard let node = node else {
            return
        }
        
        postOrder(node.right)
        print("\(node.data)", terminator: " ")
        postOrder(node.left)
    }

    func height(_ key: Node?) -> Int {
        guard let key = key else {
            return 0
        }
        return 1 + max(height(key.left), height(key.right))
    }

    func printBST(_ root: Node?, _ depth: Int, _ prefixx: Character, _ leftTrace: inout [Character], _ rightTrace: inout [Character]) {
        guard let root = root else {
            return
        }
    
        if root.left != nil {
            printBST(root.left, depth + 1, "/", &leftTrace, &rightTrace)
        }
    
        if prefixx == "/" {
            leftTrace[depth - 1] = "|"
        }
    
        if prefixx == "\\" {
            rightTrace[depth - 1] = " "
        }

        if depth == 0 {
            print("-", terminator: "")
        }
        if depth > 0 {
            print(" ", terminator: "")
        } 

        for i in 0..<depth {
            if leftTrace[i] == "|" || rightTrace[i] == "|" {
                print("| ", terminator: "")
            } else {
                print("  ", terminator: "")
            }
        }
    
        if depth > 0 {
            print("\(prefixx)-", terminator: "")
        }

        print("[\(root.data)]")
    
        leftTrace[depth] = " "
    
        if root.right != nil {
            rightTrace[depth] = "|"
            printBST(root.right, depth + 1, "\\", &leftTrace, &rightTrace)
        }
    }

}

func createTreeWithAscendingKeys(_ n: Int) -> BinarySearchTree {
    let tree = BinarySearchTree()
    for i in 0..<n {
        tree.insertNode(tree.root, i)
    }
    return tree
}

func createTreeWithRandomKeys(_ n: Int) -> BinarySearchTree {
    let tree = BinarySearchTree()
    var uniqueKeys = Set<Int>()
    
    while uniqueKeys.count < n {
        let element = Int.random(in: 0..<(2 * n - 1))
        uniqueKeys.insert(element)
    }
    
    for key in uniqueKeys {
        tree.insertNode(tree.root, key)
    }
    
    return tree
}

