import Foundation
import QuartzCore

enum Order {
    case random
    case sorted
    case reverse
}

func genList(n: UInt32, order: Order) -> [UInt32] {
    var vector: [UInt32] = []
    
    for _ in 0..<n {
        vector.append(UInt32.random(in: 0..<(2*n)))
    }
    
    switch order {
    case .random:
        return vector
    case .sorted:
        return vector.sorted()
    case .reverse:
        return vector.sorted(by: >)
    }
}

struct Lcs<T: Comparable & Equatable & CustomDebugStringConvertible> {
    let a: [T]
    let b: [T]
    let c: [[Int]]
    
    init(a: [T], b: [T]) {
        self.a = a
        self.b = b
        self.c = generateMatrix(a: a, b: b)
    }
    
    func len() -> Int {
        return c[a.count][b.count]
    }
    
    func printLcs() {
        var stack: [(Int, Int)] = [(a.count, b.count)]
        var res: [T] = []
        
        while !stack.isEmpty {
            let (x, y) = stack.popLast()!
            
            if x == 0 || y == 0 {
                continue
            }
            if a[x - 1] == b[y - 1] {
                res.append(a[x - 1])
                stack.append((x-1, y-1))
            } else if c[x][y-1] > c[x-1][y] {
                stack.append((x, y-1))
            } else {
                stack.append((x-1, y))
            }
        }
        
        res.reverse()
        print(res.debugDescription)
    }
    
    func isEmpty() -> Bool {
        return false
    }
}

func generateMatrix<T: Comparable & Equatable>(a: [T], b: [T]) -> [[Int]] {
    let m = a.count
    let n = b.count
    var c: [[Int]] = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
    
    for i in 0...m {
        for j in 0...n {
            if i == 0 || j == 0 {
                c[i][j] = 0
            } else if a[i-1] == b[j-1] {
                c[i][j] = c[i-1][j-1] + 1
            } else {
                c[i][j] = max(c[i-1][j], c[i][j-1])
            }
        }
    }
    
    return c
}

func lcsLength<T: Comparable & Equatable>(a: [T], b: [T]) -> Int {
    let c = generateMatrix(a: a, b: b)
    return c[a.count][b.count]
}

func saveToFile(content: String, fileName: String) {
    let folderName = "results1"
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

func test() {
    let fileName = "avg_time.txt"
    for n in stride(from: 1000, through: 5000, by: 1000) {
        var totalTime: Double = 0 
        for _ in 0..<50 {
            let a = genList(n: UInt32(n), order: .random)
            let b = genList(n: UInt32(n), order: .random)
            let startTime = CACurrentMediaTime()
            _ = lcsLength(a:a, b:b)
            let endTime = CACurrentMediaTime()
            totalTime += endTime - startTime
        }
        let avgTime = totalTime/Double(50)
        let content = "\(n), \(avgTime)"
        saveToFile(content: content, fileName: fileName)
    }
}
test()