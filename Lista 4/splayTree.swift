import Foundation

class Node {
    var left: Node?
    var right: Node?
    var data: Int
    var parent: Node?
    
    init(_ key: Int) {
        self.left = nil
        self.right = nil
        self.data = key
        self.parent = nil
    }
}

class SplayTree {
    var root: Node?

    func insertNode(_ key: Int) {
        guard let root = root else {
            self.root = Node(key)
            return
        }
        
        let splayed = splay(key, root)
        if key < splayed!.data {
            let newNode = Node(key)
            newNode.left = splayed!.left
            newNode.right = splayed
            splayed!.left?.parent = newNode
            splayed!.left = nil
            self.root = newNode
        } else if key > splayed!.data {
            let newNode = Node(key)
            newNode.right = splayed!.right
            newNode.left = splayed
            splayed!.right?.parent = newNode
            splayed!.right = nil
            self.root = newNode
        } else {
            self.root = splayed
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

    func deleteNode(_ key: Int, _ node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        root = splay(key, node)
        if key == root?.data {
            if root?.left == nil {
                root = root?.right
                root?.parent = nil
            } else {
                let rightSubtree = root?.right
                root = root?.left
                root = splay(key, root)
                root?.right = rightSubtree
                rightSubtree?.parent = root
                if let rightChild = root?.right {
                    rightChild.parent = nil
                }
            }
        }
        return root
    }

    func splay(_ key: Int, _ node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
    
        if key < node.data {
            guard let leftChild = node.left else {
                return node
            }
        
            if key < leftChild.data {
                leftChild.left = splay(key, leftChild.left)
                return rotateRight(node)
            } else if key > leftChild.data {
                leftChild.right = splay(key, leftChild.right)
                if let left = node.left {
                   _ = rotateLeft(left)
                }
                return rotateRight(node)
            }
        
            if let left = node.left, key == left.data {
                return rotateRight(node)
            }
        
            return node
        } else if key > node.data {
            guard let rightChild = node.right else {
                return node
            }
        
            if key > rightChild.data {
                rightChild.right = splay(key, rightChild.right)
                return rotateLeft(node)
            } else if key < rightChild.data {
                rightChild.left = splay(key, rightChild.left)
                if let right = node.right {
                    _ = rotateRight(right)
                }
                return rotateLeft(node)
            }
        
            if let right = node.right, key == right.data {
                return rotateLeft(node)
            }
        
            return node
        } else {
            return node
        }
    }


    func rotateRight(_ node: Node) -> Node? {
        guard let leftChild = node.left else {
            return nil
        }

        node.left = leftChild.right
        leftChild.right = node

        return leftChild
    }

    func rotateLeft(_ node: Node) -> Node? {
        guard let rightChild = node.right else {
            return nil
        }

        node.right = rightChild.left
        rightChild.left = node

        return rightChild
    }
    
    func findMin(_ node: Node?) -> Node? {
        var current = node
        while let left = current?.left {
            current = left
        }
        return current
    }
    
    func findMax(_ node: Node?) -> Node? {
        var current = node
        while let right = current?.right {
            current = right
        }
        return current
    }

    func successor(_ node: Node?) -> Node? {
        guard var node = node else {
            return nil
        }
        
        if node.right != nil {
            return findMin(node.right!)
        }
        
        var parent = node.parent
        while parent != nil && node === parent?.right {
            node = parent!
            parent = parent?.parent
        }
        
        return parent
    }
    
    func deleteMin(_ node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        
        if node.left == nil {
            return node.right
        }
        
        node.left = deleteMin(node.left)
        node.left?.parent = node
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
        node.right?.parent = node
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

    func getHeight(_ node: Node?) -> (Int, Int) {
            guard let node = node else {
                return (0, 0)
            }
        
            let (leftHeight, rightHeight) = getHeight(node.left)
            let (leftSubtreeLeftHeight, leftSubtreeRightHeight) = getHeight(node.right)
        
            let currentLeftHeight = 1 + max(leftSubtreeLeftHeight, leftSubtreeRightHeight)
            let currentRightHeight = 1 + max(leftHeight, rightHeight)
        
            return (currentLeftHeight, currentRightHeight)
    }

    func printHeight(_ node: Node?) {
        let (leftHeight, rightHeight) = getHeight(node)
        print("Left subtree height: \(leftHeight)")
        print("Right subtree height: \(rightHeight)")
    }

    func printST(_ root: Node?, _ depth: Int, _ prefixx: Character, _ leftTrace: inout [Character], _ rightTrace: inout [Character]) {
        guard let root = root else {
            return
        }
    
        if root.left != nil {
            printST(root.left, depth + 1, "/", &leftTrace, &rightTrace)
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
            printST(root.right, depth + 1, "\\", &leftTrace, &rightTrace)
        }
    }
}

func createTreeWithAscendingKeys(_ n: Int) -> SplayTree {
    let tree = SplayTree()
    for i in 0..<n {
        tree.insertNode(i)
    }
    return tree 
}

func createTreeWithRandomKeys(_ n: Int) -> SplayTree {
    let tree = SplayTree()
    var uniqueKeys = Set<Int>()
    
    while uniqueKeys.count < n {
        let element = Int.random(in: 0..<(2 * n - 1))
        uniqueKeys.insert(element)
    }
    
    for key in uniqueKeys {
        tree.insertNode(key)
    }
    
    return tree
}
/*
// Case 1: Wstawianie rosnącego ciągu kluczy, a następnie usuwanie losowego ciągu kluczy
let n = 20
print("Wstawianie rosnącego ciągu \(n) kluczy:")
let ascendingKeysTree = createTreeWithAscendingKeys(n)
ascendingKeysTree.printBST(ascendingKeysTree.root, 0, "-")
print()
*/
// Case 2: Wstawianie losowego ciągu kluczy, a następnie usuwanie losowego ciągu kluczy
/*
let n = 20
print("Wstawianie losowego ciągu \(n) kluczy:")
let treeWithRandomKeys = createTreeWithRandomKeys(n)
var leftTrace = [Character](repeating: " ", count: n)
var rightTrace = [Character](repeating: " ", count: n)
treeWithRandomKeys.printHeight(treeWithRandomKeys.root)
treeWithRandomKeys.printST(treeWithRandomKeys.root, 0, "-", &leftTrace, &rightTrace)
print()
*/
let splayTree = SplayTree()

// Wstawianie węzłów do drzewa
splayTree.insertNode(5)
splayTree.insertNode(3)
splayTree.insertNode(7)
splayTree.insertNode(2)
splayTree.insertNode(4)
splayTree.insertNode(6)
splayTree.insertNode(8)

print("Drzewo po wstawieniu węzłów:")
var leftTrace = [Character](repeating: " ", count: 10)
var rightTrace = [Character](repeating: " ", count: 10)
splayTree.printST(splayTree.root, 0, "-", &leftTrace, &rightTrace)
print()

// Usuwanie węzła z drzewa
let newTree = splayTree.deleteNode(4, splayTree.root)

print("Drzewo po usunięciu węzła:")
leftTrace = [Character](repeating: " ", count: 10)
rightTrace = [Character](repeating: " ", count: 10)
splayTree.printST(newTree, 0, "-", &leftTrace, &rightTrace)
print()
