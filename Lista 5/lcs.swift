import Foundation

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

func main() {
    let s1: [Character] = Array("XMJYAUZ")
    let s2: [Character] = Array("MZJAWXU")
    print("s1 = \(s1)")
    print("s2 = \(s2)")
    let lcs = Lcs(a: s1, b: s2)
    print("len = \(lcs.len())")
    lcs.printLcs()
    let s3: [Character] = Array("ACADB")
    let s4: [Character] = Array("CBDA")
    print("s1 = \(s3)")
    print("s2 = \(s4)")
    let lcs2 = Lcs(a: s3, b: s4)
    print("len = \(lcs2.len())")
    lcs2.printLcs()
}

main()