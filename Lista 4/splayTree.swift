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
        
        guard let rootNode = root, rootNode.data == key else {
            return root
        }
        
        if rootNode.left == nil {
            root = rootNode.right
            root?.parent = nil
        } else {
            let rightSubtree = rootNode.right
            root = rootNode.left
            root?.parent = nil
            if let newRoot = root {
                root = splay(findMax(newRoot)?.data ?? key, newRoot)
                root?.right = rightSubtree
                rightSubtree?.parent = root
            }
        }
        
        return root
    }

    func splay(_ key: Int, _ node: Node?) -> Node? {
        guard let root = node else {
            return nil
        }
        
        if root.data == key {
            return root
        }
        
        if key < root.data {
            if root.left == nil {
                return root
            }
            
            if key < root.left!.data {
                root.left!.left = splay(key, root.left!.left)
                root.left = rotateRight(root.left!)
            } else if key > root.left!.data {
                root.left!.right = splay(key, root.left!.right)
                if root.left!.right != nil {
                    root.left = rotateLeft(root.left!)
                }
            }
            
            return root.left == nil ? root : rotateRight(root)
        } else {
            if root.right == nil {
                return root
            }
            
            if key < root.right!.data {
                root.right!.left = splay(key, root.right!.left)
                if root.right!.left != nil {
                    root.right = rotateRight(root.right!)
                }
            } else if key > root.right!.data {
                root.right!.right = splay(key, root.right!.right)
                root.right = rotateLeft(root.right!)
            }
            
            return root.right == nil ? root : rotateLeft(root)
        }
    }

    func rotateRight(_ node: Node) -> Node? {
        guard let leftChild = node.left else {
            return nil
        }

        node.left = leftChild.right
        if let rightOfLeft = leftChild.right {
            rightOfLeft.parent = node
        }
        leftChild.right = node
        leftChild.parent = node.parent
        node.parent = leftChild

        return leftChild
    }

    func rotateLeft(_ node: Node) -> Node? {
        guard let rightChild = node.right else {
            return nil
        }

        node.right = rightChild.left
        if let leftOfRight = rightChild.left {
            leftOfRight.parent = node
        }
        rightChild.left = node
        rightChild.parent = node.parent
        node.parent = rightChild

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

let splayTree = SplayTree()

splayTree.insertNode(1)
splayTree.insertNode(2)
splayTree.insertNode(3)
splayTree.insertNode(4)
splayTree.insertNode(5)
splayTree.insertNode(6)
splayTree.insertNode(7)


print("Drzewo po wstawieniu węzłów:")
var leftTrace = [Character](repeating: " ", count: 10)
var rightTrace = [Character](repeating: " ", count: 10)
splayTree.printST(splayTree.root, 0, "-", &leftTrace, &rightTrace)
print()

let newTree = splayTree.deleteNode(4, splayTree.root)

print("Drzewo po usunięciu węzła:")
leftTrace = [Character](repeating: " ", count: 10)
rightTrace = [Character](repeating: " ", count: 10)
splayTree.printST(newTree, 0, "-", &leftTrace, &rightTrace)
print()
