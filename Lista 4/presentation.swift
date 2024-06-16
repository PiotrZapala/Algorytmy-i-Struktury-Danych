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

    func searchNode(_ root: NodeBST?, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeBST? {
        if let root = root {
            if root.data == key {
                compareCount += 1
                print("Key found")
                return root
            } else if root.data < key {
                compareCount += 1
                return searchNode(root.right, key, &compareCount, &pointerSubstitutionCount)
            } else {
                compareCount += 1
                return searchNode(root.left, key, &compareCount, &pointerSubstitutionCount)
            }
        } else {
            compareCount += 1
            print("Key not found")
            return nil
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

    func printBST(_ root: NodeBST?, _ depth: Int, _ prefixx: Character, _ leftTrace: inout [Character], _ rightTrace: inout [Character]) {
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
        if let root = root {
            if root.data == key {
                compareCount += 1
                print("Key found")
                return root
            } else if root.data < key {
                compareCount += 1
                return searchNode(root.right, key, &compareCount, &pointerSubstitutionCount)
            } else {
                compareCount += 1
                return searchNode(root.left, key, &compareCount, &pointerSubstitutionCount)
            }
        } else {
            compareCount += 1
            print("Key not found")
            return nil
        }
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

    func printRBT(_ root: NodeRBT?, _ depth: Int, _ prefixx: Character, _ leftTrace: inout [Character], _ rightTrace: inout [Character]) {
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
        
        let splayed = splay(key, root, &compareCount, &pointerSubstitutionCount)
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
    }

    func searchNode(_ root: NodeST?, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        if let root = root {
            if root.data == key {
                compareCount += 1
                print("Key found")
                return root
            } else if root.data < key {
                compareCount += 1
                return searchNode(root.right, key, &compareCount, &pointerSubstitutionCount)
            } else {
                compareCount += 1
                return searchNode(root.left, key, &compareCount, &pointerSubstitutionCount)
            }
        } else {
            compareCount += 1
            print("Key not found")
            return nil
        }
    }

    func deleteNode(_ node: NodeST?, _ key: Int, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        guard let node = node else {
            return nil
        }
        
        root = splay(key, node, &compareCount, &pointerSubstitutionCount)
        
        guard let rootNode = root, rootNode.data == key else {
            return root
        }
        
        if rootNode.left == nil {
            compareCount += 1
            root = rootNode.right
            root?.parent = nil
            pointerSubstitutionCount += 2
        } else {
            compareCount += 1
            let rightSubtree = rootNode.right
            root = rootNode.left
            root?.parent = nil
            pointerSubstitutionCount += 2
            if let newRoot = root {
                root = splay(findMax(newRoot)?.data ?? key, newRoot, &compareCount, &pointerSubstitutionCount)
                root?.right = rightSubtree
                rightSubtree?.parent = root
                pointerSubstitutionCount += 2
            }
        }
        
        return root
    }


    func splay( _ key: Int, _ node: NodeST?, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        guard let root = node else {
            return nil
        }
        
        if root.data == key {
            return root
        }
        
        if key < root.data {
            compareCount += 1
            if root.left == nil {
                compareCount += 1
                return root
            }
            
            if key < root.left!.data {
                compareCount += 1
                root.left!.left = splay(key, root.left!.left, &compareCount, &pointerSubstitutionCount)
                root.left = rotateRight(root.left!, &compareCount, &pointerSubstitutionCount)
                pointerSubstitutionCount += 2
            } else if key > root.left!.data {
                compareCount += 1
                root.left!.right = splay(key, root.left!.right, &compareCount, &pointerSubstitutionCount)
                pointerSubstitutionCount += 1
                if root.left!.right != nil {
                    compareCount += 1
                    root.left = rotateLeft(root.left!, &compareCount, &pointerSubstitutionCount)
                    pointerSubstitutionCount += 1
                }
            }
            
            return root.left == nil ? root : rotateRight(root, &compareCount, &pointerSubstitutionCount)
        } else {
            compareCount += 1
            if root.right == nil {
                compareCount += 1
                return root
            }
            
            if key < root.right!.data {
                compareCount += 1
                root.right!.left = splay(key, root.right!.left, &compareCount, &pointerSubstitutionCount)
                pointerSubstitutionCount += 1
                if root.right!.left != nil {
                    compareCount += 1
                    root.right = rotateRight(root.right!, &compareCount, &pointerSubstitutionCount)
                    pointerSubstitutionCount += 1
                }
            } else if key > root.right!.data {
                compareCount += 1
                root.right!.right = splay(key, root.right!.right, &compareCount, &pointerSubstitutionCount)
                root.right = rotateLeft(root.right!, &compareCount, &pointerSubstitutionCount)
                pointerSubstitutionCount += 2
            }
            
            return root.right == nil ? root : rotateLeft(root, &compareCount, &pointerSubstitutionCount)
        }
    }

    func rotateRight(_ node: NodeST, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        guard let leftChild = node.left else {
            return nil
        }

        node.left = leftChild.right
        compareCount += 1
        if let rightOfLeft = leftChild.right {
            rightOfLeft.parent = node
            pointerSubstitutionCount += 1
        }
        leftChild.right = node
        leftChild.parent = node.parent
        node.parent = leftChild
        pointerSubstitutionCount += 4

        return leftChild
    }

    func rotateLeft(_ node: NodeST, _ compareCount: inout Int, _ pointerSubstitutionCount: inout Int) -> NodeST? {
        guard let rightChild = node.right else {
            return nil
        }

        node.right = rightChild.left
        compareCount += 1
        if let leftOfRight = rightChild.left {
            leftOfRight.parent = node
            pointerSubstitutionCount += 1
        }
        rightChild.left = node
        rightChild.parent = node.parent
        node.parent = rightChild
        pointerSubstitutionCount += 4

        return rightChild
    }

    func height(_ root: NodeST?) -> Int {
        guard let root = root else {
            return 0
        }
        return 1 + max(height(root.left), height(root.right))
    }

    func findMax(_ node: NodeST?) -> NodeST? {
        var current = node
        while let right = current?.right {
            current = right
        }
        return current
    }

    func printST(_ root: NodeST?, _ depth: Int, _ prefixx: Character, _ leftTrace: inout [Character], _ rightTrace: inout [Character]) {
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

func main() {
    while(true) {
        print("Wybierz interesującą Cię strukturę danych!")
        print()
        print("1. Binary Search Tree")
        print("2. Red Black Tree")
        print("3. Splay Tree")
        print("4. Zamknij program")
        if let input1 = readLine(), let number1 = Int(input1) {
            switch number1 {
                case 1:
                    var cond = true 
                    let treeBST = BinarySearchTree()
                    var compareCount = 0
                    var shiftCount = 0
                    var n = 0
                    while(cond) {
                        print("Wybrałeś/aś Binary Search Tree!")
                        print("Podaj operację jaką chcesz wykonać na drzewie")
                        print("1.Insert")
                        print("2.Search")
                        print("3.Delete")
                        print("4.Get height")
                        print("5.Print tree")
                        print("6.Exit")
                        if let input2 = readLine(), let number2 = Int(input2) {
                            switch number2 {
                                case 1:
                                    print("Podaj liczbę elementów, które chcesz dodać")
                                    if let input3 = readLine(), let number3 = Int(input3) {
                                        var i = 0
                                        while i < number3 {
                                            print("Podaj element do dodania")
                                            if let input4 = readLine(), let key = Int(input4) {
                                                treeBST.insertNode(treeBST.root, key, &compareCount, &shiftCount)
                                                n += 1
                                            } else {
                                                print("Nieprawidłowe dane wejściowe.")
                                                print()
                                            }
                                            i+=1
                                        }
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 2:
                                    print("Podaj element do znalezienia")
                                    if let input4 = readLine(), let key1 = Int(input4) {
                                            _ = treeBST.searchNode(treeBST.root, key1, &compareCount, &shiftCount)
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 3:
                                    var compareCount = 0
                                    var shiftCount = 0
                                    print("Podaj liczbę elementów, które chcesz usunąć")
                                    if let input5 = readLine(), let number5 = Int(input5) {
                                        var i = 0
                                        while i < number5 {
                                            print("Podaj element do usunięcia")
                                            if let input6 = readLine(), let key2 = Int(input6) {
                                                _ = treeBST.deleteNode(treeBST.root, key2, &compareCount, &shiftCount)
                                                n-=1
                                            } else {
                                                print("Nieprawidłowe dane wejściowe.")
                                                print()
                                            }
                                            i+=1
                                        }
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 4:
                                    print("Wysokość drzewa wynosi: \(treeBST.height(treeBST.root))")
                                    print()

                                case 5:
                                    var leftTrace = [Character](repeating: " ", count: n)
                                    var rightTrace = [Character](repeating: " ", count: n)
                                    treeBST.printBST(treeBST.root, 0, "-", &leftTrace, &rightTrace)
                                    print()

                                case 6:
                                    cond = false

                                default:
                                    print("Nieprawidłowa wartość. Wybierz 1, 2, 3, 4, 5 lub 6.")
                                    print()
                            
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                    }    
                case 2:
                    var cond = true 
                    let treeRBT = RedBlackTree()
                    var compareCount = 0
                    var shiftCount = 0
                    var n = 0
                    while(cond) {
                        print("Wybrałeś/aś Red Black Tree!")
                        print("Podaj operację jaką chcesz wykonać na drzewie")
                        print("1.Insert")
                        print("2.Search")
                        print("3.Delete")
                        print("4.Get height")
                        print("5.Print tree")
                        print("6.Exit")
                        if let input2 = readLine(), let number2 = Int(input2) {
                            switch number2 {
                                case 1:
                                    print("Podaj liczbę elementów, które chcesz dodać")
                                    if let input3 = readLine(), let number3 = Int(input3) {
                                        var i = 0
                                        while i < number3 {
                                            print("Podaj element do dodania")
                                            if let input4 = readLine(), let key = Int(input4) {
                                                treeRBT.insertNode(key, &compareCount, &shiftCount)
                                                n += 1
                                            } else {
                                                print("Nieprawidłowe dane wejściowe.")
                                                print()
                                            }
                                            i+=1
                                        }
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 2:
                                    print("Podaj element do znalezienia")
                                    if let input4 = readLine(), let key1 = Int(input4) {
                                            _ = treeRBT.searchNode(treeRBT.root, key1, &compareCount, &shiftCount)
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 3:
                                    var compareCount = 0
                                    var shiftCount = 0
                                    print("Podaj liczbę elementów, które chcesz usunąć")
                                    if let input5 = readLine(), let number5 = Int(input5) {
                                        var i = 0
                                        while i < number5 {
                                            print("Podaj element do usunięcia")
                                            if let input6 = readLine(), let key2 = Int(input6) {
                                                treeRBT.deleteNode(treeRBT.root, key2, &compareCount, &shiftCount)
                                                n-=1
                                            } else {
                                                print("Nieprawidłowe dane wejściowe.")
                                                print()
                                            }
                                            i+=1
                                        }
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 4:
                                    print("Wysokość drzewa wynosi: \(treeRBT.height(treeRBT.root))")
                                    print()

                                case 5:
                                    var leftTrace = [Character](repeating: " ", count: n)
                                    var rightTrace = [Character](repeating: " ", count: n)
                                    treeRBT.printRBT(treeRBT.root, 0, "-", &leftTrace, &rightTrace)
                                    print()

                                case 6:
                                    cond = false

                                default:
                                    print("Nieprawidłowa wartość. Wybierz 1, 2, 3, 4, 5 lub 6.")
                                    print()
                            
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                    }                

                case 3:
                    var cond = true 
                    let treeST = SplayTree()
                    var compareCount = 0
                    var shiftCount = 0
                    var n = 0
                    while(cond) {
                        print("Wybrałeś/aś Splay Tree!")
                        print("Podaj operację jaką chcesz wykonać na drzewie")
                        print("1.Insert")
                        print("2.Search")
                        print("3.Delete")
                        print("4.Get height")
                        print("5.Print tree")
                        print("6.Exit")
                        if let input2 = readLine(), let number2 = Int(input2) {
                            switch number2 {
                                case 1:
                                    print("Podaj liczbę elementów, które chcesz dodać")
                                    if let input3 = readLine(), let number3 = Int(input3) {
                                        var i = 0
                                        while i < number3 {
                                            print("Podaj element do dodania")
                                            if let input4 = readLine(), let key = Int(input4) {
                                                treeST.insertNode(key, &compareCount, &shiftCount)
                                                n += 1
                                            } else {
                                                print("Nieprawidłowe dane wejściowe.")
                                                print()
                                            }
                                            i+=1
                                        }
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 2:
                                    print("Podaj element do znalezienia")
                                    if let input4 = readLine(), let key1 = Int(input4) {
                                            _ = treeST.searchNode(treeST.root, key1, &compareCount, &shiftCount)
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 3:
                                    var compareCount = 0
                                    var shiftCount = 0
                                    print("Podaj liczbę elementów, które chcesz usunąć")
                                    if let input5 = readLine(), let number5 = Int(input5) {
                                        var i = 0
                                        while i < number5 {
                                            print("Podaj element do usunięcia")
                                            if let input6 = readLine(), let key2 = Int(input6) {
                                                _ = treeST.deleteNode(treeST.root, key2, &compareCount, &shiftCount)
                                                n-=1
                                            } else {
                                                print("Nieprawidłowe dane wejściowe.")
                                                print()
                                            }
                                            i+=1
                                        }
                                    } else {
                                        print("Nieprawidłowe dane wejściowe.")
                                        print()
                                    }

                                case 4:
                                    print("Wysokość drzewa wynosi: \(treeST.height(treeST.root))")
                                    print()

                                case 5:
                                    var leftTrace = [Character](repeating: " ", count: n)
                                    var rightTrace = [Character](repeating: " ", count: n)
                                    treeST.printST(treeST.root, 0, "-", &leftTrace, &rightTrace)
                                    print()

                                case 6:
                                    cond = false

                                default:
                                    print("Nieprawidłowa wartość. Wybierz 1, 2, 3, 4, 5 lub 6.")
                                    print()
                            
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                    }

                case 4:
                    exit(0)   
                
                default:
                    print("Nieprawidłowa wartość. Wybierz 1, 2, 3 lub 4.")
                    print()
            }
        } else {
            print("Nieprawidłowe dane wejściowe.")
            print()
        }
    }
}

main()