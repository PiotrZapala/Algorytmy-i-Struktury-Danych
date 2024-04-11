import Foundation

func floor_log(_ x: Int) -> Int {
    return Int(log2(Double(x)))
}

class BinomialTree {
    var key: Int
    var children: [BinomialTree]
    var order: Int
    
    init(_ key: Int) {
        self.key = key
        self.children = []
        self.order = 0
    }
    
    func addAtEnd(_ t: BinomialTree) {
        children.append(t)
        order += 1
    }
}

class BinomialHeap {
    var trees: [BinomialTree]
    
    init() {
        self.trees = []
    }
    
    func extractMin(_ compareCount: inout Int) -> Int? {
        if trees.isEmpty {
            return nil
        }
        
        var smallestNode = trees[0]
        for tree in trees {
            compareCount += 1
            if tree.key < smallestNode.key {
                smallestNode = tree
            }
        }
        
        trees.removeAll { $0 === smallestNode }
        
        let h = BinomialHeap()
        h.trees = smallestNode.children
        
        merge(h, &compareCount)
        
        return smallestNode.key
    }
    
    func getMin(_ compareCount: inout Int) -> Int? {
        if trees.isEmpty {
            return nil
        }
        
        var least = trees[0].key
        for tree in trees {
            compareCount += 1
            if tree.key < least {
                least = tree.key
            }
        }
        
        return least
    }
    
    func combineRoots(_ h: BinomialHeap, _ compareCount: inout Int) {
        trees += h.trees
        trees.sort { $0.order < $1.order }
    }
    
    func merge(_ h: BinomialHeap, _ compareCount: inout Int) {
        combineRoots(h, &compareCount)
        
        if trees.isEmpty {
            return
        }
        
        var i = 0
        while i < trees.count - 1 {
            let current = trees[i]
            let after = trees[i + 1]
            
            if current.order == after.order {
                if i + 1 < trees.count - 1 && trees[i + 2].order == after.order {
                    let afterAfter = trees[i + 2]
                    compareCount += 1
                    if after.key < afterAfter.key {
                        after.addAtEnd(afterAfter)
                        trees.remove(at: i + 2)
                    } else {
                        afterAfter.addAtEnd(after)
                        trees.remove(at: i + 1)
                    }
                } else {
                    compareCount += 1
                    if current.key < after.key {
                        current.addAtEnd(after)
                        trees.remove(at: i + 1)
                    } else {
                        after.addAtEnd(current)
                        trees.remove(at: i)
                    }
                }
            }
            
            i += 1
        }
    }
    
    func insert(_ key: Int, _ compareCount: inout Int) {
        let g = BinomialHeap()
        g.trees.append(BinomialTree(key))
        merge(g, &compareCount)
    }
}

class FibonacciTree {
    var value: Int
    var child: [FibonacciTree]
    var order: Int
    
    init(_ value: Int) {
        self.value = value
        self.child = []
        self.order = 0
    }
    
    func addAtEnd(_ t: FibonacciTree) {
        child.append(t)
        order += 1
    }
}

class FibonacciHeap {
    var trees: [FibonacciTree]
    var least: FibonacciTree?
    var count: Int
    
    init() {
        self.trees = []
        self.least = nil
        self.count = 0
    }
    
    func insert(_ value: Int, _ compareCount: inout Int) {
        let newTree = FibonacciTree(value)
        trees.append(newTree)
        
        compareCount += 1
        if least == nil || value < least!.value {
            least = newTree
        }
        
        count += 1
    }
    
    func getMin() -> Int? {
        if least == nil {
            return nil
        }
        
        return least!.value
    }
    
    func extractMin(_ compareCount: inout Int) -> Int? {
        let smallest = least
        if smallest != nil {
            for child in smallest!.child {
                trees.append(child)
            }
            
            trees.removeAll { $0 === smallest }
            
            if trees.isEmpty {
                least = nil
            } else {
                least = trees[0]
                consolidate(&compareCount)
            }
            
            count -= 1
            
            return smallest!.value
        }
        
        return nil
    }
    
    func consolidate(_ compareCount: inout Int) {
        var aux = [FibonacciTree?](repeating: nil, count: (floor_log(count) + 1))
        
        while !trees.isEmpty {
            let x = trees[0]
            let order = x.order
            trees.remove(at: 0)
            
            while aux[order] != nil {
                let y = aux[order]!
                compareCount += 1
                if x.value > y.value {
                    (x.value, y.value) = (y.value, x.value)
                }
                
                x.addAtEnd(y)
                aux[order] = nil
                aux[order + 1] = x
            }
            
            aux[order] = x
        }
        
        least = nil
        
        for k in aux {
            if let tree = k {
                trees.append(tree)
                compareCount += 1
                if least == nil || tree.value < least!.value {
                    least = tree
                }
            }
        }
    }
    
    func merge(_ otherHeap: FibonacciHeap, _ compareCount: inout Int) {
        trees += otherHeap.trees
        compareCount += 1
        if least == nil || (otherHeap.least != nil && otherHeap.least!.value < least!.value) {
            least = otherHeap.least
        }
        count += otherHeap.count
    }
}

func saveToFile(content: String, fileName: String) {
    let folderName = "results"
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
    var compareCount1 = 0
    var compareCount2 = 0    
    var content : String
    let nValues = [500, 1000]
    
    for n in nValues {
        for k in 0..<5 {
            let fileName1 = "test_bin_1_\(k)_\(n).txt"
            let fileName2 = "test_fib_1_\(k)_\(n).txt"
            var i = 0
            compareCount1 = 0
            let heap1 = BinomialHeap()
            content = "\(i),\(compareCount1)"
            saveToFile(content: content, fileName: fileName1)
            compareCount1 = 0
            let heap2 = BinomialHeap()
            i += 1
            content = "\(i),\(compareCount1)"
            saveToFile(content: content, fileName: fileName1)
            
            for _ in 0..<n {
                compareCount1 = 0
                heap1.insert(Int.random(in: 0..<(2 * n - 1)), &compareCount1)
                i += 1
                content = "\(i),\(compareCount1)"
                saveToFile(content: content, fileName: fileName1)
            }
            
            for _ in 0..<n {
                compareCount1 = 0
                heap2.insert(Int.random(in: 0..<(2 * n - 1)), &compareCount1)
                i += 1
                content = "\(i),\(compareCount1)"
                saveToFile(content: content, fileName: fileName1)
            }
            
            compareCount1 = 0
            heap1.merge(heap2, &compareCount1)
            i += 1
            content = "\(i),\(compareCount1)"
            saveToFile(content: content, fileName: fileName1)
            
            for _ in 0..<(2 * n) {
                compareCount1 = 0
                heap1.extractMin(&compareCount1)
                i += 1
                content = "\(i),\(compareCount1)"
                saveToFile(content: content, fileName: fileName1)
            }
            
            i = 0
            compareCount2 = 0
            let heap3 = FibonacciHeap()
            content = "\(i),\(compareCount2)"
            saveToFile(content: content, fileName: fileName2)
            compareCount2 = 0
            let heap4 = FibonacciHeap()
            i += 1
            content = "\(i),\(compareCount2)"
            saveToFile(content: content, fileName: fileName2)
            
            for _ in 0..<n {
                compareCount2 = 0
                heap3.insert(Int.random(in: 0..<(2 * n - 1)), &compareCount2)
                i += 1
                content = "\(i),\(compareCount2)"
                saveToFile(content: content, fileName: fileName2)
            }
            
            for _ in 0..<n {
                compareCount2 = 0
                heap4.insert(Int.random(in: 0..<(2 * n - 1)), &compareCount2)
                i += 1
                content = "\(i),\(compareCount2)"
                saveToFile(content: content, fileName: fileName2)
            }
            
            compareCount2 = 0
            heap3.merge(heap4, &compareCount2)
            i += 1
            content = "\(i),\(compareCount2)"
            saveToFile(content: content, fileName: fileName2)
            
            for _ in 0..<(2 * n) {
                compareCount2 = 0
                heap3.extractMin(&compareCount2)
                i += 1
                content = "\(i),\(compareCount2)"
                saveToFile(content: content, fileName: fileName2)
            }
        }
    }
}

func test2() {
    var compareCount1 = 0
    var compareCount2 = 0
    
    let fileName = "test_2.txt"
    
    for n in stride(from: 100, through: 10000, by: 100) {
        let heap1 = BinomialHeap()
        let heap2 = BinomialHeap()
        
        for _ in 0..<n {
            heap1.insert(Int.random(in: 0..<(2 * n - 1)), &compareCount1)
            heap2.insert(Int.random(in: 0..<(2 * n - 1)), &compareCount1)
        }
        
        heap1.merge(heap2, &compareCount1)
        
        for _ in 0..<(2 * n) {
            heap1.extractMin(&compareCount1)
        }

        let heap3 = FibonacciHeap()
        let heap4 = FibonacciHeap()
        
        for _ in 0..<n {
            heap3.insert(Int.random(in: 0..<(2 * n - 1)), &compareCount2)
            heap4.insert(Int.random(in: 0..<(2 * n - 1)), &compareCount2)
        }
        
        heap3.merge(heap4, &compareCount2)
        
        for _ in 0..<(2 * n) {
            heap3.extractMin(&compareCount2)
        }
        let content = "\(n),\(compareCount1),\(compareCount2)"
        saveToFile(content: content, fileName: fileName)
    }
}

test1()
test2()