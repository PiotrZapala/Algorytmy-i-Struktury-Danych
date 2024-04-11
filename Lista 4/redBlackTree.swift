import Foundation

class Node {
    var data: Int
    var parent: Node?
    var left: Node?
    var right: Node?
    var color: Int
    
    init(_ data: Int) {
        self.data = data
        self.parent = nil
        self.left = nil
        self.right = nil
        self.color = 1
    }
}

class RedBlackTree {
    var data: Node
    var root: Node
    
    init() {
        self.data = Node(0)
        self.data.color = 0
        self.data.left = nil
        self.data.right = nil
        self.root = self.data
    }
    
    func insertNode(_ key: Int) {
        let node = Node(key)
        node.parent = nil
        node.left = self.data
        node.right = self.data
        node.color = 1
        
        var current = root
        var parent: Node? = nil
        
        while current !== self.data {
            parent = current
            
            if key < current.data {
                current = current.left ?? self.data
            } else {
                current = current.right ?? self.data
            }
        }
        
        node.parent = parent
        
        if parent == nil {
            self.root = node
        } else if key < parent!.data {
            parent?.left = node
        } else {
            parent?.right = node
        }
        
        if node.parent == nil {
            node.color = 0
        } else if node.parent?.parent != nil {
            fixInsert(node)
        }
    }
    
    func searchNode(_ root: Node?, _ key: Int) -> Node? {
        guard let root = root else {
            print("Key doesn't exist")
            return nil
        }
        
        //route.append(root.data)
        
        if root.data == key {
            //print("Key \(key) found. Route is: \(route)")
            return root
        }
        
        if root.data < key {
            return searchNode(root.right, key)
        }
        
        return searchNode(root.left, key)
    }
    
    func deleteNode(_ node: Node, _ key: Int) {
        guard let data = searchNode(root, key) else {
            return
        }
        
        var dt = data
        var dataColor = dt.color
        
        var x: Node?
        
        if data.left === self.data {
            x = data.right
            rbTransplant(data, data.right ?? self.data)
        } else if data.right === self.data {
            x = data.left
            rbTransplant(data, data.left ?? self.data)
        } else {
            dt = findMin(data.right ?? self.data)!
            dataColor = dt.color
            x = dt.right
            
            if dt.parent === data {
                x?.parent = dt
            } else {
                rbTransplant(dt, dt.right ?? self.data)
                dt.right = data.right
                dt.right?.parent = dt
            }
            
            rbTransplant(data, dt)
            dt.left = data.left
            dt.left?.parent = dt
            dt.color = data.color
        }
        
        if dataColor == 0 {
            fixDelete(x)
        }
    }

    
    func fixDelete(_ node: Node?) {
        guard let node = node else {
            return
        }
    
        var currentNode = node
    
        while currentNode !== root && currentNode.color == 0 {
            if currentNode === currentNode.parent?.left {
                var sibling = currentNode.parent?.right
            
                if sibling?.color == 1 {
                    sibling?.color = 0
                    currentNode.parent?.color = 1
                    rotateLeft(currentNode.parent)
                    sibling = currentNode.parent?.right
                }
            
                if sibling?.left?.color == 0 && sibling?.right?.color == 0 {
                    sibling?.color = 1
                    currentNode = currentNode.parent!
                } else {
                    if sibling?.right?.color == 0 {
                        sibling?.left?.color = 0
                        sibling?.color = 1
                        rotateRight(sibling)
                        sibling = currentNode.parent?.right
                    }
                
                    sibling?.color = currentNode.parent?.color ?? 0
                    currentNode.parent?.color = 0
                    sibling?.right?.color = 0
                    rotateLeft(currentNode.parent)
                    currentNode = root
                }
            } else {
                var sibling = currentNode.parent?.left
            
                if sibling?.color == 1 {
                    sibling?.color = 0
                    currentNode.parent?.color = 1
                    rotateRight(currentNode.parent)
                    sibling = currentNode.parent?.left
                }
            
                if sibling?.left?.color == 0 && sibling?.right?.color == 0 {
                    sibling?.color = 1
                    currentNode = currentNode.parent!
                } else {
                    if sibling?.left?.color == 0 {
                        sibling?.right?.color = 0
                        sibling?.color = 1
                        rotateLeft(sibling)
                        sibling = currentNode.parent?.left
                    }
                
                    sibling?.color = currentNode.parent?.color ?? 0
                    currentNode.parent?.color = 0
                    sibling?.left?.color = 0
                    rotateRight(currentNode.parent)
                    currentNode = root
                }
            }
        }
    
        currentNode.color = 0
    }

    
    func rbTransplant(_ u: Node, _ v: Node) {
        if u.parent == nil {
            root = v
        } else if u === u.parent?.left {
            u.parent?.left = v
        } else {
            u.parent?.right = v
        }
        
        v.parent = u.parent
    }
    
    func fixInsert(_ key: Node) {
        var key = key
    
        while let parent = key.parent, parent.color == 1 {
            if parent === parent.parent?.right {
                if let u = parent.parent?.left, u.color == 1 {
                    u.color = 0
                    parent.color = 0
                    parent.parent?.color = 1
                    key = parent.parent!
                } else {
                    if key === parent.left {
                        key = parent
                        rotateRight(key)
                    }
                
                    key.parent?.color = 0
                    key.parent?.parent?.color = 1
                    if let grandparent = key.parent?.parent {
                        rotateLeft(grandparent)
                    }
                }
            } else {
                if let u = parent.parent?.right, u.color == 1 {
                    u.color = 0
                    parent.color = 0
                    parent.parent?.color = 1
                    key = parent.parent!
                } else {
                    if key === parent.right {
                        key = parent
                        rotateLeft(key)
                    }
                
                    key.parent?.color = 0
                    key.parent?.parent?.color = 1
                    if let grandparent = key.parent?.parent {
                        rotateRight(grandparent)
                    }
                }
            }
        
            if key === root {
                break
            }
        }
    
        root.color = 0
    }

    func rotateLeft(_ node: Node?) {
        guard let node = node else {
            return
        }

        let right = node.right
        node.right = right?.left

        if right?.left !== self.data {
            right?.left?.parent = node
        }

        right?.parent = node.parent

        if node.parent == nil {
            self.root = right!
        } else if node === node.parent?.left {
            node.parent?.left = right
        } else {
            node.parent?.right = right
        }

        right?.left = node
        node.parent = right
    }

    func rotateRight(_ node: Node?) {
        guard let node = node else {
            return
        }

        let left = node.left
        node.left = left?.right

        if left?.right !== self.data {
            left?.right?.parent = node
        }

        left?.parent = node.parent

        if node.parent == nil {
            self.root = left!
        } else if node === node.parent?.right {
            node.parent?.right = left
        } else {
            node.parent?.left = left
        }

        left?.right = node
        node.parent = left
    }


    
    func findMin(_ node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }

        var currentNode = node
        while currentNode.left != nil {
            currentNode = currentNode.left!
        }

        return currentNode
    }

    
    func findMax(_ node: Node?) -> Int? {
        guard let startNode = node else {
            return nil
        }
    
        var currentNode = startNode
        while currentNode.right != nil {
            currentNode = currentNode.right!
        }
    
        return currentNode.data
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
    
    func height(_ node: Node?) -> Int {
        guard let node = node else {
            return 0
        }   
        return 1 + max(height(node.left), height(node.right))
    }


    func printRBT(_ root: Node?, _ depth: Int, _ prefixx: Character, _ leftTrace: inout [Character], _ rightTrace: inout [Character]) {
        guard let root = root else {
            return
        }
    
        if root.left != nil {
            printRBT(root.left, depth + 1, "/", &leftTrace, &rightTrace)
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
            printRBT(root.right, depth + 1, "\\", &leftTrace, &rightTrace)
        }
    }
}

func createTreeWithAscendingKeys(_ n: Int) -> RedBlackTree {
    let tree = RedBlackTree()
    for i in 0..<n {
        tree.insertNode(i)
    }
    return tree
}

func createTreeWithRandomKeys(_ n: Int) -> RedBlackTree {
    let tree = RedBlackTree()
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

let n = 20
print("Wstawianie losowego ciągu \(n) kluczy:")
let randomKeysTree = createTreeWithRandomKeys(n)
var leftTrace = [Character](repeating: " ", count: n)
var rightTrace = [Character](repeating: " ", count: n)

randomKeysTree.printRBT(randomKeysTree.root, 0, "-", &leftTrace, &rightTrace)
print()