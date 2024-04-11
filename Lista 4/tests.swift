import Foundation

class NodeBST {
    var left: NodeBST?
    var right: NodeBST?
    var data: Int

    init(_ key: Int) {
        self.left = nil
        self.right = nil
        self.data = key
    }
}

class BinarySearchTree {
    var root: NodeBST?

    func insertNode(_ root: NodeBST?, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        let node = NodeBST(key)
        if let root = root {
            compareCount += 1
            if root.data < node.data {
                compareCount += 1
                if root.right == nil {
                    compareCount += 1
                    root.right = node
                    pointerSubstitutionCount += 1
                } else {
                    compareCount += 1
                    insertNode(root.right, node.data, &compareCount, &pointerSubstitutionCount)
                }
            } else {
                compareCount += 1
                if root.left == nil {
                    compareCount += 1
                    root.left = node
                    pointerSubstitutionCount += 1
                } else {
                    compareCount += 1
                    insertNode(root.left, node.data, &compareCount, &pointerSubstitutionCount)
                }
            }
        } else {
            compareCount += 1
            self.root = node
            pointerSubstitutionCount += 1
        }
    }

    func deleteNode(_ root: NodeBST?, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeBST? {
        guard let root = root else {
            return nil
        }

        if key < root.data {
            compareCount += 1
            root.left = deleteNode(root.left, key, &compareCount, &pointerSubstitutionCount)
            pointerSubstitutionCount += 1
        } else if key > root.data {
            compareCount += 1
            root.right = deleteNode(root.right, key, &compareCount, &pointerSubstitutionCount)
            pointerSubstitutionCount += 1
        } else {
            compareCount += 1
            if root.left == nil {
                compareCount += 1
                return root.right
            } else if root.right == nil {
                compareCount += 1
                return root.left
            }

            if let temp = findMin(root.right, &compareCount, &pointerSubstitutionCount) {
                compareCount += 1
                root.data = temp
                pointerSubstitutionCount += 1
                root.right = deleteNode(root.right, temp, &compareCount, &pointerSubstitutionCount)
            }
        }
        return root
    }

    func findMin(_ node: NodeBST?, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> Int? {
        var current = node
        while let left = current?.left {
            pointerSubstitutionCount += 1
            current = left
        }
        return current?.data
    }
    

    func height(_ root: NodeBST?) -> Int {
        guard let root = root else {
            return 0
        }
        return 1 + max(height(root.left), height(root.right))
    }
}

class NodeRBT {
    var data: Int
    var parent: NodeRBT?
    var left: NodeRBT?
    var right: NodeRBT?
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
    var data: NodeRBT
    var root: NodeRBT
    
    init() {
        self.data = NodeRBT(0)
        self.data.color = 0
        self.data.left = nil
        self.data.right = nil
        self.root = self.data
    }
    
    func insertNode(_ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        let node = NodeRBT(key)
        node.parent = nil
        node.left = self.data
        node.right = self.data
        pointerSubstitutionCount += 3
        node.color = 1
        
        var current = root
        var parent: NodeRBT? = nil
        
        while current !== self.data {
            compareCount += 1
            parent = current
            pointerSubstitutionCount += 1
            
            if key < current.data {
                compareCount += 1
                current = current.left ?? self.data
                pointerSubstitutionCount += 1
            } else {
                compareCount += 1
                current = current.right ?? self.data
                pointerSubstitutionCount += 1
            }
        }
        
        node.parent = parent
        pointerSubstitutionCount += 1
        
        if parent == nil {
            compareCount += 1
            self.root = node
            pointerSubstitutionCount += 1
        } else if key < parent!.data {
            compareCount += 1
            parent?.left = node
            pointerSubstitutionCount += 1
        } else {
            compareCount += 1
            parent?.right = node
            pointerSubstitutionCount += 1
        }
        
        if node.parent == nil {
            compareCount += 1
            node.color = 0
        } else if node.parent?.parent != nil {
            compareCount += 1
            fixInsert(node, &compareCount, &pointerSubstitutionCount)
        }
    }
    
    func searchNode(_ root: NodeRBT?, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeRBT? {
        guard let root = root else {
            return nil
        }
        
        if root.data == key {
            compareCount += 1
            return root
        }
        
        if root.data < key {
            compareCount += 1
            return searchNode(root.right, key, &compareCount, &pointerSubstitutionCount)
        }
        
        return searchNode(root.left, key, &compareCount, &pointerSubstitutionCount)
    }
    
    func deleteNode(_ node: NodeRBT, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        guard let data = searchNode(root, key, &compareCount, &pointerSubstitutionCount) else {
            return
        }
        
        var dt = data
        var dataColor = dt.color
        
        var x: NodeRBT?
        
        if data.left === self.data {
            compareCount += 1
            x = data.right
            pointerSubstitutionCount += 1
            rbTransplant(data, data.right ?? self.data, &compareCount, &pointerSubstitutionCount)
        } else if data.right === self.data {
            compareCount += 1
            x = data.left
            pointerSubstitutionCount += 1
            rbTransplant(data, data.left ?? self.data, &compareCount, &pointerSubstitutionCount)
        } else {
            compareCount += 1
            dt = findMin(data.right ?? self.data, &compareCount, &pointerSubstitutionCount)!
            dataColor = dt.color
            x = dt.right
            pointerSubstitutionCount += 1
            
            if dt.parent === data {
                compareCount += 1
                x?.parent = dt
                pointerSubstitutionCount += 1
            } else {
                compareCount += 1
                rbTransplant(dt, dt.right ?? self.data, &compareCount, &pointerSubstitutionCount)
                dt.right = data.right
                dt.right?.parent = dt
                pointerSubstitutionCount += 2
            }
            
            rbTransplant(data, dt, &compareCount, &pointerSubstitutionCount)
            dt.left = data.left
            dt.left?.parent = dt
            pointerSubstitutionCount += 2
            dt.color = data.color
        }
        
        if dataColor == 0 {
            fixDelete(x, &compareCount, &pointerSubstitutionCount)
        }
    }

    
    func fixDelete(_ node: NodeRBT?, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        guard let node = node else {
            return
        }
    
        var currentNode = node
    
        while currentNode !== root && currentNode.color == 0 {
            compareCount += 1
            if currentNode === currentNode.parent?.left {
                compareCount += 1
                var sibling = currentNode.parent?.right
            
                if sibling?.color == 1 {
                    sibling?.color = 0
                    currentNode.parent?.color = 1
                    rotateLeft(currentNode.parent, &compareCount, &pointerSubstitutionCount)
                    sibling = currentNode.parent?.right
                    pointerSubstitutionCount += 1
                }
            
                if sibling?.left?.color == 0 && sibling?.right?.color == 0 {
                    sibling?.color = 1
                    currentNode = currentNode.parent!
                    pointerSubstitutionCount += 1
                } else {
                    if sibling?.right?.color == 0 {
                        sibling?.left?.color = 0
                        sibling?.color = 1
                        rotateRight(sibling, &compareCount, &pointerSubstitutionCount)
                        sibling = currentNode.parent?.right
                        pointerSubstitutionCount += 1
                    }
                
                    sibling?.color = currentNode.parent?.color ?? 0
                    currentNode.parent?.color = 0
                    sibling?.right?.color = 0
                    rotateLeft(currentNode.parent, &compareCount, &pointerSubstitutionCount)
                    currentNode = root
                    pointerSubstitutionCount += 1
                }
            } else {
                var sibling = currentNode.parent?.left
            
                if sibling?.color == 1 {
                    sibling?.color = 0
                    currentNode.parent?.color = 1
                    rotateRight(currentNode.parent, &compareCount, &pointerSubstitutionCount)
                    sibling = currentNode.parent?.left
                    pointerSubstitutionCount += 1
                }
            
                if sibling?.left?.color == 0 && sibling?.right?.color == 0 {
                    sibling?.color = 1
                    currentNode = currentNode.parent!
                    pointerSubstitutionCount += 1
                } else {
                    if sibling?.left?.color == 0 {
                        sibling?.right?.color = 0
                        sibling?.color = 1
                        rotateLeft(sibling, &compareCount, &pointerSubstitutionCount)
                        sibling = currentNode.parent?.left
                        pointerSubstitutionCount += 1
                    }
                
                    sibling?.color = currentNode.parent?.color ?? 0
                    currentNode.parent?.color = 0
                    sibling?.left?.color = 0
                    rotateRight(currentNode.parent, &compareCount, &pointerSubstitutionCount)
                    currentNode = root
                    pointerSubstitutionCount += 1
                }
            }
        }
    
        currentNode.color = 0
    }

    
    func rbTransplant(_ u: NodeRBT, _ v: NodeRBT, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        if u.parent == nil {
            compareCount += 1
            root = v
            pointerSubstitutionCount += 1
        } else if u === u.parent?.left {
            compareCount += 1
            u.parent?.left = v
            pointerSubstitutionCount += 1
        } else {
            compareCount += 1
            u.parent?.right = v
            pointerSubstitutionCount += 1
        }
        
        v.parent = u.parent
        pointerSubstitutionCount += 1
    }
    
    func fixInsert(_ key: NodeRBT, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        var key = key
    
        while let parent = key.parent, parent.color == 1 {
            compareCount += 1
            if parent === parent.parent?.right {
                compareCount += 1
                if let u = parent.parent?.left, u.color == 1 {
                    compareCount += 1
                    u.color = 0
                    parent.color = 0
                    parent.parent?.color = 1
                    key = parent.parent!
                    pointerSubstitutionCount += 1
                } else {
                    compareCount += 1
                    if key === parent.left {
                        compareCount += 1
                        key = parent
                        pointerSubstitutionCount += 1
                        rotateRight(key, &compareCount, &pointerSubstitutionCount)
                    }
                
                    key.parent?.color = 0
                    key.parent?.parent?.color = 1
                    if let grandparent = key.parent?.parent {
                        compareCount += 1
                        rotateLeft(grandparent, &compareCount, &pointerSubstitutionCount)
                    }
                }
            } else {
                compareCount += 1
                if let u = parent.parent?.right, u.color == 1 {
                    compareCount += 1
                    u.color = 0
                    parent.color = 0
                    parent.parent?.color = 1
                    key = parent.parent!
                    pointerSubstitutionCount += 1
                } else {
                    compareCount += 1
                    if key === parent.right {
                        compareCount += 1
                        key = parent
                        pointerSubstitutionCount += 1
                        rotateLeft(key, &compareCount, &pointerSubstitutionCount)
                    }
                
                    key.parent?.color = 0
                    key.parent?.parent?.color = 1
                    if let grandparent = key.parent?.parent {
                        compareCount += 1
                        rotateRight(grandparent, &compareCount, &pointerSubstitutionCount)
                    }
                }
            }
        
            if key === root {
                compareCount += 1
                break
            }
        }
    
        root.color = 0
    }

    func rotateLeft(_ node: NodeRBT?, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        guard let node = node else {
            return
        }

        let right = node.right
        node.right = right?.left
        pointerSubstitutionCount += 1

        if right?.left !== self.data {
            compareCount += 1
            right?.left?.parent = node
            pointerSubstitutionCount += 1
        }

        right?.parent = node.parent
        pointerSubstitutionCount += 1

        if node.parent == nil {
            compareCount += 1
            self.root = right!
            pointerSubstitutionCount += 1
        } else if node === node.parent?.left {
            compareCount += 1
            node.parent?.left = right
            pointerSubstitutionCount += 1
        } else {
            compareCount += 1
            node.parent?.right = right
            pointerSubstitutionCount += 1
        }

        right?.left = node
        node.parent = right
        pointerSubstitutionCount += 2
    }

    func rotateRight(_ node: NodeRBT?, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        guard let node = node else {
            return
        }

        let left = node.left
        node.left = left?.right
        pointerSubstitutionCount += 1

        if left?.right !== self.data {
            compareCount += 1
            left?.right?.parent = node
            pointerSubstitutionCount += 1
        }

        left?.parent = node.parent
        pointerSubstitutionCount += 1

        if node.parent == nil {
            compareCount += 1
            self.root = left!
            pointerSubstitutionCount += 1
        } else if node === node.parent?.right {
            compareCount += 1
            node.parent?.right = left
            pointerSubstitutionCount += 1
        } else {
            compareCount += 1
            node.parent?.left = left
            pointerSubstitutionCount += 1
        }

        left?.right = node
        node.parent = left
        pointerSubstitutionCount += 2
    }

    func findMin(_ node: NodeRBT?, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeRBT? {
        guard let node = node else {
            return nil
        }

        var currentNode = node
        while currentNode.left != nil {
            compareCount += 1
            currentNode = currentNode.left!
            pointerSubstitutionCount += 1
        }

        return currentNode
    }
    
    func height(_ root: NodeRBT?) -> Int {
        guard let root = root else {
            return 0
        }
        return 1 + max(height(root.left), height(root.right))
    }
}

class NodeST {
    var left: NodeST?
    var right: NodeST?
    var data: Int
    var parent: NodeST?
    
    init(_ key: Int) {
        self.left = nil
        self.right = nil
        self.data = key
        self.parent = nil
    }
}

class SplayTree {
    var root: NodeST?

    func insertNode(_ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) {
        guard let root = root else {
            self.root = NodeST(key)
            return
        }
        
        let splayed = splay(root, key, &compareCount, &pointerSubstitutionCount)
        if key < splayed!.data {
            compareCount += 1
            let newNode = NodeST(key)
            newNode.left = splayed!.left
            newNode.right = splayed
            splayed!.left?.parent = newNode
            splayed!.left = nil
            self.root = newNode
            pointerSubstitutionCount += 5
        } else if key > splayed!.data {
            compareCount += 1
            let newNode = NodeST(key)
            newNode.right = splayed!.right
            newNode.left = splayed
            splayed!.right?.parent = newNode
            splayed!.right = nil
            self.root = newNode
            pointerSubstitutionCount += 5
        } else {
            compareCount += 1
            self.root = splayed
            pointerSubstitutionCount += 1
        }
        _ = splay(root, key, &compareCount, &pointerSubstitutionCount)
    }

    func deleteNode(_ node: NodeST?, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        guard let node = node else {
            return nil
        }
        root = splay(node, key, &compareCount, &pointerSubstitutionCount)
        if key == root?.data {
            compareCount += 1
            if root?.left == nil {
                compareCount += 1
                root = root?.right
                root?.parent = nil
                pointerSubstitutionCount += 2
            } else {
                compareCount += 1
                let rightSubtree = root?.right
                root = root?.left
                root = splay(root, key, &compareCount, &pointerSubstitutionCount)
                root?.right = rightSubtree
                rightSubtree?.parent = root
                pointerSubstitutionCount += 4
                if let rightChild = root?.right {
                    compareCount += 1
                    rightChild.parent = nil
                    pointerSubstitutionCount += 1
                }
            }
        }
        return root
    }

    func splay (_ node: NodeST?, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        guard let node = node else {
            return nil
        }
    
        if key < node.data {
            compareCount += 1
            guard let leftChild = node.left else {
                return node
            }
        
            if key < leftChild.data {
                compareCount += 1
                leftChild.left = splay(leftChild.left, key, &compareCount, &pointerSubstitutionCount)
                pointerSubstitutionCount += 1
                return rotateRight(node, &compareCount, &pointerSubstitutionCount)
            } else if key > leftChild.data {
                compareCount += 1
                leftChild.right = splay(leftChild.right, key, &compareCount, &pointerSubstitutionCount)
                pointerSubstitutionCount += 1
                if let left = node.left {
                    compareCount += 1
                   _ = rotateLeft(left, &compareCount, &pointerSubstitutionCount)
                }
                return rotateRight(node, &compareCount, &pointerSubstitutionCount)
            }
        
            if let left = node.left, key == left.data {
                compareCount += 1
                return rotateRight(node, &compareCount, &pointerSubstitutionCount)
            }
        
            return node
        } else if key > node.data {
            compareCount += 1
            guard let rightChild = node.right else {
                return node
            }
        
            if key > rightChild.data {
                compareCount += 1
                rightChild.right = splay(rightChild.right, key, &compareCount, &pointerSubstitutionCount)
                pointerSubstitutionCount += 1
                return rotateLeft(node, &compareCount, &pointerSubstitutionCount)
            } else if key < rightChild.data {
                compareCount += 1
                rightChild.left = splay(rightChild.left, key, &compareCount, &pointerSubstitutionCount)
                pointerSubstitutionCount += 1
                if let right = node.right {
                    compareCount += 1
                    _ = rotateRight(right, &compareCount, &pointerSubstitutionCount)
                }
                return rotateLeft(node, &compareCount, &pointerSubstitutionCount)
            }
        
            if let right = node.right, key == right.data {
                compareCount += 1
                return rotateLeft(node, &compareCount, &pointerSubstitutionCount)
            }
        
            return node
        } else {
            return node
        }
    }


    func rotateRight(_ node: NodeST, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        guard let leftChild = node.left else {
            return nil
        }

        node.left = leftChild.right
        leftChild.right = node
        pointerSubstitutionCount += 2

        return leftChild
    }

    func rotateLeft(_ node: NodeST, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        guard let rightChild = node.right else {
            return nil
        }

        node.right = rightChild.left
        rightChild.left = node
        pointerSubstitutionCount += 2

        return rightChild
    }

    func height(_ root: NodeST?) -> Int {
        guard let root = root else {
            return 0
        }
        return 1 + max(height(root.left), height(root.right))
    }
}

func generateRandomKeys(_ n: Int) -> Set<Int> {
    var uniqueKeys = Set<Int>()
    while uniqueKeys.count < n {
        let element = Int.random(in: 0..<(2 * n - 1))
        uniqueKeys.insert(element)
    }
    return uniqueKeys
}

func sortKeysAscending(_ keys: [Int]) -> [Int] {
    return keys.sorted()
}

func saveToFile(content: String, fileName: String) {
    let folderName = "stResultsAsc"
    let currentDirectory = FileManager.default.currentDirectoryPath
    let folderURL = URL(fileURLWithPath: currentDirectory).appendingPathComponent(folderName)
    let fileURL = folderURL.appendingPathComponent(fileName)
    do {
        let contentWithNewLine = content + "\n" // Dodaj nową linię na końcu zawartości
        if FileManager.default.fileExists(atPath: folderURL.path) == false {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        }
        if FileManager.default.fileExists(atPath: fileURL.path) == false {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
        let fileHandle = try FileHandle(forWritingTo: fileURL)
        fileHandle.seekToEndOfFile()
        fileHandle.write(contentWithNewLine.data(using: .utf8)!)
        fileHandle.closeFile()
    } catch {
        print("Błąd podczas zapisu do pliku \(fileName): \(error)")
    }
}

func test1() {
    let k = 20
    for n in stride(from: 10000, through: 100000, by: 10000) {
        var totalCompareCountInsertRandBST: [Int] = []
        var totalCompareCountInsertRandRBT: [Int] = []
        var totalCompareCountInsertRandST: [Int] = []

        var totalPointerSubstitutionCountInsertRandBST: [Int] = []
        var totalPointerSubstitutionCountInsertRandRBT: [Int] = []
        var totalPointerSubstitutionCountInsertRandST: [Int] = []

        var totalCompareCountDeleteRandBST: [Int] = []
        var totalCompareCountDeleteRandRBT: [Int] = []
        var totalCompareCountDeleteRandST: [Int] = []

        var totalPointerSubstitutionCountDeleteRandBST: [Int] = []
        var totalPointerSubstitutionCountDeleteRandRBT: [Int] = [] 
        var totalPointerSubstitutionCountDeleteRandST: [Int] = []

        var totalCompareCountInsertAscBST: [Int] = []
        var totalCompareCountInsertAscRBT: [Int] = []
        var totalCompareCountInsertAscST: [Int] = []

        var totalPointerSubstitutionCountInsertAscBST: [Int] = []
        var totalPointerSubstitutionCountInsertAscRBT: [Int] = []
        var totalPointerSubstitutionCountInsertAscST: [Int] = []

        var totalCompareCountDeleteAscBST: [Int] = []
        var totalCompareCountDeleteAscRBT: [Int] = []
        var totalCompareCountDeleteAscST: [Int] = []

        var totalPointerSubstitutionCountDeleteAscBST: [Int] = []
        var totalPointerSubstitutionCountDeleteAscRBT: [Int] = []
        var totalPointerSubstitutionCountDeleteAscST: [Int] = []

        var heightOfRandKeysBST: [Int] = []
        var heightOfRandKeysRBT: [Int] = []
        var heightOfRandKeysST: [Int] = []
        var heightOfAscKeysBST: [Int] = []
        var heightOfAscKeysRBT: [Int] = []
        var heightOfAscKeysST: [Int] = []

        for _ in 0..<k {   
            let randSet = generateRandomKeys(n)
            let randArr = Array(randSet)
            let rand = randArr
            let ascArr = sortKeysAscending(rand)

            var compareCountInsertRandBST = 0
            var compareCountInsertRandRBT = 0
            var compareCountInsertRandST = 0

            var pointerSubstitutionCountInsertRandBST = 0
            var pointerSubstitutionCountInsertRandRBT = 0
            var pointerSubstitutionCountInsertRandST = 0

            var compareCountDeleteRandBST = 0
            var compareCountDeleteRandRBT = 0
            var compareCountDeleteRandST = 0

            var pointerSubstitutionCountDeleteRandBST = 0
            var pointerSubstitutionCountDeleteRandRBT = 0
            var pointerSubstitutionCountDeleteRandST = 0

            var compareCountInsertAscBST = 0
            var compareCountInsertAscRBT = 0
            var compareCountInsertAscST = 0

            var pointerSubstitutionCountInsertAscBST = 0
            var pointerSubstitutionCountInsertAscRBT = 0
            var pointerSubstitutionCountInsertAscST = 0

            var compareCountDeleteAscBST = 0
            var compareCountDeleteAscRBT = 0
            var compareCountDeleteAscST = 0

            var pointerSubstitutionCountDeleteAscBST = 0
            var pointerSubstitutionCountDeleteAscRBT = 0
            var pointerSubstitutionCountDeleteAscST = 0

            let treeRandKeysBST = BinarySearchTree()
            let treeRandKeysRBT = RedBlackTree()
            let treeRandKeysST = SplayTree()
            let treeAscKeysBST = BinarySearchTree()
            let treeAscKeysRBT = RedBlackTree()
            let treeAscKeysST = SplayTree()

            for i in 0..<n {
                let randKey = randArr[i]
                let ascKey = ascArr[i]
                treeRandKeysBST.insertNode(treeRandKeysBST.root, randKey, &compareCountInsertRandBST, &pointerSubstitutionCountInsertRandBST)
                treeRandKeysRBT.insertNode(randKey, &compareCountInsertRandRBT, &pointerSubstitutionCountInsertRandRBT)
                treeRandKeysST.insertNode(randKey, &compareCountInsertRandST, &pointerSubstitutionCountInsertRandST)
                treeAscKeysBST.insertNode(treeAscKeysBST.root, ascKey, &compareCountInsertAscBST, &pointerSubstitutionCountInsertAscBST)
                treeAscKeysRBT.insertNode(ascKey, &compareCountInsertAscRBT, &pointerSubstitutionCountInsertAscRBT)
                treeAscKeysST.insertNode(ascKey, &compareCountInsertAscST, &pointerSubstitutionCountInsertAscST)
            }

            heightOfRandKeysBST.append(treeRandKeysBST.height(treeRandKeysBST.root))
            heightOfRandKeysRBT.append(treeRandKeysRBT.height(treeRandKeysRBT.root))
            heightOfRandKeysST.append(treeRandKeysST.height(treeRandKeysST.root))
            heightOfAscKeysBST.append(treeAscKeysBST.height(treeAscKeysBST.root))
            heightOfAscKeysRBT.append(treeAscKeysRBT.height(treeAscKeysRBT.root))
            heightOfAscKeysST.append(treeAscKeysST.height(treeAscKeysST.root))
            
            for i in 0..<n {
                let randKey = randArr[i]
                let ascKey = ascArr[i]
                _ = treeRandKeysBST.deleteNode(treeRandKeysBST.root, randKey, &compareCountDeleteRandBST, &pointerSubstitutionCountDeleteRandBST)
                treeRandKeysRBT.deleteNode(treeRandKeysRBT.root, randKey, &compareCountDeleteRandRBT, &pointerSubstitutionCountDeleteRandRBT)
                _ = treeRandKeysST.deleteNode(treeRandKeysST.root, randKey, &compareCountDeleteRandST, &pointerSubstitutionCountDeleteRandST)
                _ = treeAscKeysBST.deleteNode(treeAscKeysBST.root, ascKey, &compareCountDeleteAscBST, &pointerSubstitutionCountDeleteAscBST)
                treeAscKeysRBT.deleteNode(treeAscKeysRBT.root, ascKey, &compareCountDeleteAscRBT, &pointerSubstitutionCountDeleteAscRBT)
                _ = treeAscKeysST.deleteNode(treeAscKeysST.root, ascKey, &compareCountDeleteAscST, &pointerSubstitutionCountDeleteAscST)
            }
            
            totalCompareCountInsertRandBST.append(compareCountInsertRandBST)
            totalCompareCountInsertRandRBT.append(compareCountInsertRandRBT)
            totalCompareCountInsertRandST.append(compareCountInsertRandST)

            totalPointerSubstitutionCountInsertRandBST.append(pointerSubstitutionCountInsertRandBST)
            totalPointerSubstitutionCountInsertRandRBT.append(pointerSubstitutionCountInsertRandRBT)
            totalPointerSubstitutionCountInsertRandST.append(pointerSubstitutionCountInsertRandST)

            totalCompareCountDeleteRandBST.append(compareCountDeleteRandBST)
            totalCompareCountDeleteRandRBT.append(compareCountDeleteRandRBT)
            totalCompareCountDeleteRandST.append(compareCountDeleteRandST)

            totalPointerSubstitutionCountDeleteRandBST.append(pointerSubstitutionCountDeleteRandBST)
            totalPointerSubstitutionCountDeleteRandRBT.append(pointerSubstitutionCountDeleteRandRBT)
            totalPointerSubstitutionCountDeleteRandST.append(pointerSubstitutionCountDeleteRandST)

            totalCompareCountInsertAscBST.append(compareCountInsertAscBST)
            totalCompareCountInsertAscRBT.append(compareCountInsertAscRBT)
            totalCompareCountInsertAscST.append(compareCountInsertAscST)

            totalPointerSubstitutionCountInsertAscBST.append(pointerSubstitutionCountInsertAscBST)
            totalPointerSubstitutionCountInsertAscRBT.append(pointerSubstitutionCountInsertAscRBT)
            totalPointerSubstitutionCountInsertAscST.append(pointerSubstitutionCountInsertAscST)

            totalCompareCountDeleteAscBST.append(compareCountDeleteAscBST)
            totalCompareCountDeleteAscRBT.append(compareCountDeleteAscRBT)
            totalCompareCountDeleteAscST.append(compareCountDeleteAscST)

            totalPointerSubstitutionCountDeleteAscBST.append(pointerSubstitutionCountDeleteAscBST)
            totalPointerSubstitutionCountDeleteAscRBT.append(pointerSubstitutionCountDeleteAscRBT)
            totalPointerSubstitutionCountDeleteAscST.append(pointerSubstitutionCountDeleteAscST)
            
        }
        let maxHeightOfRandKeysBST = heightOfRandKeysBST.max()
        let maxHeightOfRandKeysRBT = heightOfRandKeysRBT.max()
        let maxHeightOfRandKeysST = heightOfRandKeysST.max()

        let avgHeightOfRandKeysBST = heightOfRandKeysBST.reduce(0,+)/k
        let avgHeightOfRandKeysRBT = heightOfRandKeysRBT.reduce(0,+)/k
        let avgHeightOfRandKeysST = heightOfRandKeysST.reduce(0,+)/k

        let maxHeightOfAscKeysBST = heightOfAscKeysBST.max()
        let maxHeightOfAscKeysRBT = heightOfAscKeysRBT.max()
        let maxHeightOfAscKeysST = heightOfAscKeysST.max()

        let avgHeightOfAscKeysBST = heightOfAscKeysBST.reduce(0,+)/k
        let avgHeightOfAscKeysRBT = heightOfAscKeysRBT.reduce(0,+)/k
        let avgHeightOfAscKeysST = heightOfAscKeysST.reduce(0,+)/k
        let maxCompareCountInsertRandBST = totalCompareCountInsertRandBST.max()
        let maxCompareCountInsertRandRBT = totalCompareCountInsertRandRBT.max()
        let maxCompareCountInsertRandST = totalCompareCountInsertRandST.max()

        let avgCompareCountInsertRandBST = totalCompareCountInsertRandBST.reduce(0,+)/k
        let avgCompareCountInsertRandRBT = totalCompareCountInsertRandRBT.reduce(0,+)/k
        let avgCompareCountInsertRandST = totalCompareCountInsertRandST.reduce(0,+)/k

        let maxPointerSubstitutionCountInsertRandBST = totalPointerSubstitutionCountInsertRandBST.max()
        let maxPointerSubstitutionCountInsertRandRBT = totalPointerSubstitutionCountInsertRandRBT.max()
        let maxPointerSubstitutionCountInsertRandST = totalPointerSubstitutionCountInsertRandST.max()

        let avgPointerSubstitutionCountInsertRandBST = totalPointerSubstitutionCountInsertRandBST.reduce(0,+)/k
        let avgPointerSubstitutionCountInsertRandRBT = totalPointerSubstitutionCountInsertRandRBT.reduce(0,+)/k
        let avgPointerSubstitutionCountInsertRandST = totalPointerSubstitutionCountInsertRandST.reduce(0,+)/k

        let maxCompareCountDeleteRandBST = totalCompareCountDeleteRandBST.max()
        let maxCompareCountDeleteRandRBT = totalCompareCountDeleteRandRBT.max()
        let maxCompareCountDeleteRandST = totalCompareCountDeleteRandST.max()

        let avgCompareCountDeleteRandBST = totalCompareCountDeleteRandBST.reduce(0,+)/k
        let avgCompareCountDeleteRandRBT = totalCompareCountDeleteRandRBT.reduce(0,+)/k
        let avgCompareCountDeleteRandST = totalCompareCountDeleteRandST.reduce(0,+)/k

        let maxPointerSubstitutionCountDeleteRandBST = totalPointerSubstitutionCountDeleteRandBST.max()
        let maxPointerSubstitutionCountDeleteRandRBT = totalPointerSubstitutionCountDeleteRandRBT.max()
        let maxPointerSubstitutionCountDeleteRandST = totalPointerSubstitutionCountDeleteRandST.max()

        let avgPointerSubstitutionCountDeleteRandBST = totalPointerSubstitutionCountDeleteRandBST.reduce(0,+)/k
        let avgPointerSubstitutionCountDeleteRandRBT = totalPointerSubstitutionCountDeleteRandRBT.reduce(0,+)/k
        let avgPointerSubstitutionCountDeleteRandST = totalPointerSubstitutionCountDeleteRandST.reduce(0,+)/k
        
        let maxCompareCountInsertAscBST = totalCompareCountInsertAscBST.max()
        let maxCompareCountInsertAscRBT = totalCompareCountInsertAscRBT.max()
        let maxCompareCountInsertAscST = totalCompareCountInsertAscST.max()

        let avgCompareCountInsertAscBST = totalCompareCountInsertAscBST.reduce(0,+)/k
        let avgCompareCountInsertAscRBT = totalCompareCountInsertAscRBT.reduce(0,+)/k
        let avgCompareCountInsertAscST = totalCompareCountInsertAscST.reduce(0,+)/k

        let maxPointerSubstitutionCountInsertAscBST = totalPointerSubstitutionCountInsertAscBST.max()
        let maxPointerSubstitutionCountInsertAscRBT = totalPointerSubstitutionCountInsertAscRBT.max()
        let maxPointerSubstitutionCountInsertAscST = totalPointerSubstitutionCountInsertAscST.max()

        let avgPointerSubstitutionCountInsertAscBST = totalPointerSubstitutionCountInsertAscBST.reduce(0,+)/k
        let avgPointerSubstitutionCountInsertAscRBT = totalPointerSubstitutionCountInsertAscRBT.reduce(0,+)/k
        let avgPointerSubstitutionCountInsertAscST = totalPointerSubstitutionCountInsertAscST.reduce(0,+)/k

        let maxCompareCountDeleteAscBST = totalCompareCountDeleteAscBST.max()
        let maxCompareCountDeleteAscRBT = totalCompareCountDeleteAscRBT.max()
        let maxCompareCountDeleteAscST = totalCompareCountDeleteAscST.max()

        let avgCompareCountDeleteAscBST = totalCompareCountDeleteAscBST.reduce(0,+)/k
        let avgCompareCountDeleteAscRBT = totalCompareCountDeleteAscRBT.reduce(0,+)/k
        let avgCompareCountDeleteAscST = totalCompareCountDeleteAscST.reduce(0,+)/k

        let maxPointerSubstitutionCountDeleteAscBST = totalPointerSubstitutionCountDeleteAscBST.max()
        let maxPointerSubstitutionCountDeleteAscRBT = totalPointerSubstitutionCountDeleteAscRBT.max()
        let maxPointerSubstitutionCountDeleteAscST = totalPointerSubstitutionCountDeleteAscST.max()

        let avgPointerSubstitutionCountDeleteAscBST = totalPointerSubstitutionCountDeleteAscBST.reduce(0,+)/k
        let avgPointerSubstitutionCountDeleteAscRBT = totalPointerSubstitutionCountDeleteAscRBT.reduce(0,+)/k
        let avgPointerSubstitutionCountDeleteAscST = totalPointerSubstitutionCountDeleteAscST.reduce(0,+)/k
        
        let content1 = "\(String(describing: n)),\(String(describing: avgCompareCountInsertRandBST)),\(String(describing: avgCompareCountInsertRandRBT)),\(String(describing: avgCompareCountInsertRandST))"
        let fileName1 = "avg_comps_insert_rand.txt"
        saveToFile(content: content1, fileName: fileName1)
        
        let content2 = "\(String(describing: n)),\(String(describing: avgCompareCountInsertAscBST)),\(String(describing: avgCompareCountInsertAscRBT)),\(String(describing: avgCompareCountInsertAscST))"
        let fileName2 = "avg_comps_insert_asc.txt"
        saveToFile(content: content2, fileName: fileName2)
        
        let content3 = "\(String(describing: n)),\(String(describing: avgCompareCountDeleteRandBST)),\(String(describing: avgCompareCountDeleteRandRBT)),\(String(describing: avgCompareCountDeleteRandST))"
        let fileName3 = "avg_comps_delete_rand.txt"
        saveToFile(content: content3, fileName: fileName3)
        
        let content4 = "\(String(describing: n)),\(String(describing: avgCompareCountDeleteAscBST)),\(String(describing: avgCompareCountDeleteAscRBT)),\(String(describing: avgCompareCountDeleteAscST))"
        let fileName4 = "avg_comps_delete_asc.txt"
        saveToFile(content: content4, fileName: fileName4)
        
        let content5 = "\(String(describing: n)),\(String(describing: avgPointerSubstitutionCountInsertRandBST)),\(String(describing: avgPointerSubstitutionCountInsertRandRBT)),\(String(describing: avgPointerSubstitutionCountInsertRandST))"
        let fileName5 = "avg_pointer_substitution_insert_rand.txt"
        saveToFile(content: content5, fileName: fileName5)
        
        let content6 = "\(String(describing: n)),\(String(describing: avgPointerSubstitutionCountInsertAscBST)),\(String(describing: avgPointerSubstitutionCountInsertAscRBT)),\(String(describing: avgPointerSubstitutionCountInsertAscST))"
        let fileName6 = "avg_pointer_substitution_insert_asc.txt"
        saveToFile(content: content6, fileName: fileName6)
        
        let content7 = "\(String(describing: n)),\(String(describing: avgPointerSubstitutionCountDeleteRandBST)),\(String(describing: avgPointerSubstitutionCountDeleteRandRBT)),\(String(describing: avgPointerSubstitutionCountDeleteRandST))"
        let fileName7 = "avg_pointer_substitution_delete_rand.txt"
        saveToFile(content: content7, fileName: fileName7)
        
        let content8 = "\(String(describing: n)),\(String(describing: avgPointerSubstitutionCountDeleteAscBST)),\(String(describing: avgPointerSubstitutionCountDeleteAscRBT)),\(String(describing: avgPointerSubstitutionCountDeleteAscST))"
        let fileName8 = "avg_pointer_substitution_delete_asc.txt"
        saveToFile(content: content8, fileName: fileName8)
        
        let content9 = "\(String(describing: n)),\(String(describing: maxCompareCountInsertRandBST)),\(String(describing: maxCompareCountInsertRandRBT)),\(String(describing: maxCompareCountInsertRandST))"
        let fileName9 = "max_comps_insert_rand.txt"
        saveToFile(content: content9, fileName: fileName9)
        
        let content10 = "\(String(describing: n)),\(String(describing: maxCompareCountInsertAscBST)),\(String(describing: maxCompareCountInsertAscRBT)),\(String(describing: maxCompareCountInsertAscST))"
        let fileName10 = "max_comps_insert_asc.txt"
        saveToFile(content: content10, fileName: fileName10)
        
        let content11 = "\(String(describing: n)),\(String(describing: maxPointerSubstitutionCountInsertRandBST)),\(String(describing: maxPointerSubstitutionCountInsertRandRBT)),\(String(describing: maxPointerSubstitutionCountInsertRandST))"
        let fileName11 = "max_pointer_substitution_insert_rand.txt"
        saveToFile(content: content11, fileName: fileName11)
        
        let content12 = "\(String(describing: n)),\(String(describing: maxPointerSubstitutionCountInsertAscBST)),\(String(describing: maxPointerSubstitutionCountInsertAscRBT)),\(String(describing: maxPointerSubstitutionCountInsertAscST))"
        let fileName12 = "max_pointer_substitution_insert_asc.txt"
        saveToFile(content: content12, fileName: fileName12)

        let content13 = "\(String(describing: n)),\(String(describing: maxCompareCountDeleteRandBST)),\(String(describing: maxCompareCountDeleteRandRBT)),\(String(describing: maxCompareCountDeleteRandST))"
        let fileName13 = "max_comps_delete_rand.txt"
        saveToFile(content: content13, fileName: fileName13)
        
        let content14 = "\(String(describing: n)),\(String(describing: maxCompareCountDeleteAscBST)),\(String(describing: maxCompareCountDeleteAscRBT)),\(String(describing: maxCompareCountDeleteAscST))"
        let fileName14 = "max_comps_delete_asc.txt"
        saveToFile(content: content14, fileName: fileName14)
        
        let content15 = "\(String(describing: n)),\(String(describing: maxPointerSubstitutionCountDeleteRandBST)),\(String(describing: maxPointerSubstitutionCountDeleteRandRBT)),\(String(describing: maxPointerSubstitutionCountDeleteRandST))"
        let fileName15 = "max_pointer_substitution_delete_rand.txt"
        saveToFile(content: content15, fileName: fileName15)
        
        let content16 = "\(String(describing: n)),\(String(describing: maxPointerSubstitutionCountDeleteAscBST)),\(String(describing: maxPointerSubstitutionCountDeleteAscRBT)),\(String(describing: maxPointerSubstitutionCountDeleteAscST))"
        let fileName16 = "max_pointer_substitution_delete_asc.txt"
        saveToFile(content: content16, fileName: fileName16)
        
        let content17 = "\(String(describing: n)),\(String(describing: maxHeightOfRandKeysBST)),\(String(describing: maxHeightOfRandKeysRBT)),\(String(describing: maxHeightOfRandKeysST))"
        let fileName17 = "max_height_rand.txt"
        saveToFile(content: content17, fileName: fileName17)
        
        let content18 = "\(String(describing: n)),\(String(describing: maxHeightOfAscKeysBST)),\(String(describing: maxHeightOfAscKeysRBT)),\(String(describing: maxHeightOfAscKeysST))"
        let fileName18 = "max_height_asc.txt"
        saveToFile(content: content18, fileName: fileName18)
        
        let content19 = "\(String(describing: n)),\(String(describing: avgHeightOfRandKeysBST)),\(String(describing: avgHeightOfRandKeysRBT)),\(String(describing: avgHeightOfRandKeysST))"
        let fileName19 = "avg_height_rand.txt"
        saveToFile(content: content19, fileName: fileName19)
        
        let content20 = "\(String(describing: n)),\(String(describing: avgHeightOfAscKeysBST)),\(String(describing: avgHeightOfAscKeysRBT)),\(String(describing: avgHeightOfAscKeysST))"
        let fileName20 = "avg_height_asc.txt"
        saveToFile(content: content20, fileName: fileName20)
        
    }
}

test1()
