import Foundation
import QuartzCore

func generateRandomKeys(_ n: Int) -> [Int] {
    var randomKeys = [Int]()
    for _ in 1...n {
        randomKeys.append(Int.random(in: 0...2*n-1))
    }
    return randomKeys
}

func sortKeysAscending(_ keys: [Int]) -> [Int] {
    return keys.sorted()
}

func sortKeysDescending(_ keys: [Int]) -> [Int] {
    return keys.sorted(by: >)
}

func printArray(_ myArray: [Int]) {
    for element in myArray {
        print(String(format: "%02d", element), terminator: " ")
    }
    print()
}

func checkIfSorted(_ myArray: [Int]) {
    var isSorted = true
    for i in 1..<myArray.count {
        if myArray[i] < myArray[i - 1] {
            isSorted = false
            break
        }
    }
    if isSorted == true {
        print("Tablica została pomyślnie posortowana!")
    } else {
        print("Tablica nie została pomyślnie posortowana!")
    }
}

func swap(_ myArray: inout [Int], _ first: Int, _ second: Int, _ shiftCount: inout Int) {
    let temp = myArray[first]
    myArray[first] = myArray[second]
    myArray[second] = temp
    shiftCount += 1
}

func compare(_ type: String, _ first: Int, _ second: Int, _ compareCount: inout Int) -> Bool {
    compareCount += 1
    // x < y
    if type == "lt" {
        if first < second {
            return true
        } else {
            return false
        }
    }
    // x > y
    else if type == "gt" {
        if first > second {
            return true
        } else {
            return false
        }
    }
    // x <= y
    else if type == "le" {
        if first <= second {
            return true
        } else {
            return false
        }
    }
    // x >= y
    else if type == "ge" {
        if first >= second {
            return true
        } else {
            return false
        }
    }
    else {
        return false
    }
}

func insertionSort(_ myArray: inout [Int], _ compareCount: inout Int, _ shiftCount: inout Int) {
    for j in 1..<myArray.count {
        let key = myArray[j]
        var i = j - 1
        while i >= 0 && compare("gt", myArray[i], key, &compareCount) {
            myArray[i+1] = myArray[i]
            i -= 1
            shiftCount += 1
        }
        myArray[i+1] = key
    }
}

func merge(_ myArray: inout [Int], _ start: Int, _ mid: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) {

    let length1 = mid - start + 1
    let length2 = end - mid

    var leftArray = [Int](repeating: 0, count: length1)
    var rightArray = [Int](repeating: 0, count: length2)

    for i in 0..<length1 {
        leftArray[i] = myArray[start + i]
    }

    for j in 0..<length2 {
        rightArray[j] = myArray[mid + 1 + j]
    }

    var i = 0
    var j = 0
    var k = start

    while i < length1 && j < length2 {
        if compare("le", leftArray[i], rightArray[j], &compareCount) {
            myArray[k] = leftArray[i]
            i += 1
        } else {
            myArray[k] = rightArray[j]
            j += 1
        }
        k += 1
    }

    while i < length1 {
        myArray[k] = leftArray[i]
        i += 1
        k += 1
    }

    while j < length2 {
        myArray[k] = rightArray[j]
        j += 1
        k += 1
    }
}

func mergeSort(_ myArray: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) {
    if start < end {
        let mid = start + (end - start) / 2
        mergeSort(&myArray, start, mid, &compareCount, &shiftCount)
        mergeSort(&myArray, mid + 1, end, &compareCount, &shiftCount)
        merge(&myArray, start, mid, end, &compareCount, &shiftCount)
    }
}

func onePivotPartition(_ myArray: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) -> Int {
    let x = myArray[end]
    var i = start - 1
    for j in start..<end {
        if compare("le", myArray[j], x, &compareCount) {
            i += 1 
            swap(&myArray, i, j, &shiftCount)
        }
    }
    swap(&myArray, i + 1, end, &shiftCount)
    return i + 1
}

func quickSort(_ myArray: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) {
    if start < end {
        let pivot = onePivotPartition(&myArray, start, end, &compareCount, &shiftCount)
        quickSort(&myArray, start, pivot - 1, &compareCount, &shiftCount)
        quickSort(&myArray, pivot + 1, end, &compareCount, &shiftCount)
    }
}

func dualPivotPartition(_ myArray: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) -> (Int, Int) {
    var p = myArray[start]
    var q = myArray[end]

    if compare("lt", q, p, &compareCount) {
        swap(&myArray, start, end, &shiftCount)
        p = myArray[start]
        q = myArray[end]
    }
    
    var j = start + 1
    var k = j
    var g = end - 1
    
    while k <= g {
        if compare("lt", myArray[k], p, &compareCount) {
            swap(&myArray, k, j, &shiftCount)
            j += 1
        } else if compare("ge", myArray[k], q, &compareCount) {
            while compare("gt", myArray[g], q, &compareCount) && k < g {
                g -= 1
            }
            swap(&myArray, k, g, &shiftCount)
            g -= 1
            if compare("lt", myArray[k], p, &compareCount) {
                swap(&myArray, k, j, &shiftCount)
                j += 1
            }
        }
        k += 1
    }
    
    j -= 1
    g += 1
    
    swap(&myArray, start, j, &shiftCount)
    swap(&myArray, end, g, &shiftCount)
    
    return (j, g)
}


func dualPivotQuickSort(_ myArray: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) {
    if start < end {
        let (leftPivot, rightPivot) = dualPivotPartition(&myArray, start, end, &compareCount, &shiftCount)
        dualPivotQuickSort(&myArray, start, leftPivot - 1, &compareCount, &shiftCount)
        dualPivotQuickSort(&myArray, leftPivot + 1, rightPivot - 1, &compareCount, &shiftCount)
        dualPivotQuickSort(&myArray, rightPivot + 1, end, &compareCount, &shiftCount)
    }
}

func insertionHybridSort(_ myArray: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) {
    for j in start+1..<end+1 {
        let key = myArray[j]
        var i = j
        while i > start && compare("gt", myArray[i-1], key, &compareCount) {
            myArray[i] = myArray[i-1]
            i -= 1
            shiftCount += 1
        }
        myArray[i] = key
    }
}

func hybridSort(_ myArray: inout [Int], _ startIndex: Int, _ endIndex: Int, _ compareCount: inout Int, _ shiftCount: inout Int) {
    var start = startIndex
    var end = endIndex
    while start < end {
        if end - start + 1 < 10 {
            insertionHybridSort(&myArray, start, end, &compareCount, &shiftCount) 
            break
        } else {
            let pivot = onePivotPartition(&myArray, start, end, &compareCount, &shiftCount)
            if pivot - start < end - pivot {
                hybridSort(&myArray, start, pivot - 1, &compareCount, &shiftCount)
                start = pivot + 1
            } else {
                hybridSort(&myArray, pivot + 1, end, &compareCount, &shiftCount)
                end = pivot - 1
            }
        }
    }
}

func testHybridSort(_ myArray: inout [Int], _ startIndex: Int, _ endIndex: Int, _ compareCount: inout Int, _ shiftCount: inout Int, _ bound: Int) {
    var start = startIndex
    var end = endIndex
    while start < end {
        if end - start + 1 < bound {
            insertionHybridSort(&myArray, start, end, &compareCount, &shiftCount) 
            break
        } else {
            let pivot = onePivotPartition(&myArray, start, end, &compareCount, &shiftCount)
            if pivot - start < end - pivot {
                hybridSort(&myArray, start, pivot - 1, &compareCount, &shiftCount)
                start = pivot + 1
            } else {
                hybridSort(&myArray, pivot + 1, end, &compareCount, &shiftCount)
                end = pivot - 1
            }
        }
    }
}

func customMerge(_ left: [Int], _ right: [Int], _ compareCount: inout Int, _ shiftCount: inout Int) -> [Int] {
    var result: [Int] = []
    var i = 0
    var j = 0
    while i < left.count && j < right.count {
        if compare("lt", left[i], right[j], &compareCount){
            result.append(left[i])
            i += 1
        } else {
            result.append(right[j])
            j += 1
        }
    }
    result.append(contentsOf: left[i...])
    result.append(contentsOf: right[j...])
    return result
}

func findNaturalRuns(_ arr: [Int], _ compareCount: inout Int, _ shiftCount: inout Int) -> [[Int]] {
    var runs: [[Int]] = []
    var start = 0
    for i in 1..<arr.count {
        if compare("lt", arr[i], arr[i-1], &compareCount) {
            runs.append(Array(arr[start..<i]))
            start = i
        }
    }
    runs.append(Array(arr[start..<arr.count]))
    return runs
}

func customSort(_ arr: [Int], _ compareCount: inout Int, _ shiftCount: inout Int) -> [Int] {
    var runs = findNaturalRuns(arr, &compareCount, &shiftCount)
    while runs.count > 1 {
        var newRuns: [[Int]] = []
        for i in stride(from: 0, to: runs.count, by: 2) {
            if i + 1 < runs.count {
                let mergedRun = customMerge(runs[i], runs[i + 1], &compareCount, &shiftCount)
                newRuns.append(mergedRun)
            } else {
                newRuns.append(runs[i])
            }
        }
        runs = newRuns
    }
    return runs.first ?? []
}

func saveToFile(content: String, fileName: String) {
    let folderName = "result"
    let currentDirectory = FileManager.default.currentDirectoryPath
    let folderURL = URL(fileURLWithPath: currentDirectory).appendingPathComponent(folderName)
    let fileURL = folderURL.appendingPathComponent(fileName)
    do {
        let contentWithNewLine = content + "\n"
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
    let k = [1, 10, 100]
    for i in 0..<3 {
        for n in stride(from: 10, through: 200, by: 10) {
            var totalCompareCount1 = 0
            var totalCompareCount2 = 0
            var totalCompareCount3 = 0
            var totalCompareCount4 = 0
            var totalCompareCount5 = 0
            var totalCompareCount6 = 0
            var totalShiftCount1 = 0
            var totalShiftCount2 = 0
            var totalShiftCount3 = 0
            var totalShiftCount4 = 0
            var totalShiftCount5 = 0   
            var totalShiftCount6 = 0
            var totalTime1: Double = 0
            var totalTime2: Double = 0
            var totalTime3: Double = 0
            var totalTime4: Double = 0
            var totalTime5: Double = 0
            var totalTime6: Double = 0
            for _ in 0..<k[i] {   
                let randArr = generateRandomKeys(n)
                var randArr1 = randArr
                var randArr2 = randArr
                var randArr3 = randArr
                var randArr4 = randArr
                var randArr5 = randArr
                var randArr6 = randArr
                var compareCount1 = 0
                var compareCount2 = 0
                var compareCount3 = 0
                var compareCount4 = 0
                var compareCount5 = 0
                var compareCount6 = 0
                var shiftCount1 = 0
                var shiftCount2 = 0
                var shiftCount3 = 0
                var shiftCount4 = 0
                var shiftCount5 = 0
                var shiftCount6 = 0

                let startTime1 = CACurrentMediaTime()
                insertionSort(&randArr1, &compareCount1, &shiftCount1)
                let endTime1 = CACurrentMediaTime()
                totalTime1 += endTime1 - startTime1

                let startTime2 = CACurrentMediaTime()
                mergeSort(&randArr2, 0, randArr2.count-1, &compareCount2, &shiftCount2)
                let endTime2 = CACurrentMediaTime()
                totalTime2 += endTime2 - startTime2

                let startTime3 = CACurrentMediaTime()
                quickSort(&randArr3, 0, randArr3.count-1, &compareCount3, &shiftCount3)
                let endTime3 = CACurrentMediaTime()
                totalTime3 += endTime3 - startTime3

                let startTime4 = CACurrentMediaTime()
                dualPivotQuickSort(&randArr4, 0, randArr4.count-1, &compareCount4, &shiftCount4)
                let endTime4 = CACurrentMediaTime()
                totalTime4 += endTime4 - startTime4

                let startTime5 = CACurrentMediaTime()
                hybridSort(&randArr5, 0, randArr5.count-1, &compareCount5, &shiftCount5)
                let endTime5 = CACurrentMediaTime()
                totalTime5 += endTime5 - startTime5

                let startTime6 = CACurrentMediaTime()
                customSort(randArr6, &compareCount6, &shiftCount6)
                let endTime6 = CACurrentMediaTime()
                totalTime6 += endTime6 - startTime6

                totalCompareCount1 += compareCount1
                totalCompareCount2 += compareCount2
                totalCompareCount3 += compareCount3
                totalCompareCount4 += compareCount4
                totalCompareCount5 += compareCount5
                totalCompareCount6 += compareCount6
                totalShiftCount1 += shiftCount1
                totalShiftCount2 += shiftCount2
                totalShiftCount3 += shiftCount3
                totalShiftCount4 += shiftCount4
                totalShiftCount5 += shiftCount5
                totalShiftCount6 += shiftCount6
            }
            var avgCompareCount1 = totalCompareCount1/k[i]
            var avgCompareCount2 = totalCompareCount2/k[i]
            var avgCompareCount3 = totalCompareCount3/k[i]
            var avgCompareCount4 = totalCompareCount4/k[i]
            var avgCompareCount5 = totalCompareCount5/k[i]
            var avgCompareCount6 = totalCompareCount6/k[i]

            var avgShiftCount1 = totalShiftCount1/k[i]
            var avgShiftCount2 = totalShiftCount2/k[i]
            var avgShiftCount3 = totalShiftCount3/k[i]
            var avgShiftCount4 = totalShiftCount4/k[i]
            var avgShiftCount5 = totalShiftCount5/k[i]
            var avgShiftCount6 = totalShiftCount6/k[i]

            let avgCompareCountSize1 = avgCompareCount1/n
            let avgCompareCountSize2 = avgCompareCount2/n
            let avgCompareCountSize3 = avgCompareCount3/n
            let avgCompareCountSize4 = avgCompareCount4/n
            let avgCompareCountSize5 = avgCompareCount5/n
            let avgCompareCountSize6 = avgCompareCount6/n

            let avgShiftCountSize1 = avgShiftCount1/n
            let avgShiftCountSize2 = avgShiftCount2/n
            let avgShiftCountSize3 = avgShiftCount3/n
            let avgShiftCountSize4 = avgShiftCount4/n
            let avgShiftCountSize5 = avgShiftCount5/n    
            let avgShiftCountSize6 = avgShiftCount6/n

            let avgTime1 = totalTime1/Double(k[i])
            let avgTime2 = totalTime2/Double(k[i])
            let avgTime3 = totalTime3/Double(k[i])
            let avgTime4 = totalTime4/Double(k[i])
            let avgTime5 = totalTime5/Double(k[i])
            let avgTime6 = totalTime6/Double(k[i])


            let fileName1 = "avg_comps_\(k[i]).txt"
            let fileName2 = "avg_shifts_\(k[i]).txt"   
            let fileName3 = "comps_size_\(k[i]).txt"
            let fileName4 = "shifts_size_\(k[i]).txt"   
            let fileName5 = "avg_time_\(k[i]).txt"    

            let content1 = "\(n),\(avgCompareCount1),\(avgCompareCount2),\(avgCompareCount3),\(avgCompareCount4),\(avgCompareCount5),\(avgCompareCount6)"
            saveToFile(content: content1, fileName: fileName1)  
            let content2 = "\(n),\(avgShiftCount1),\(avgShiftCount2),\(avgShiftCount3),\(avgShiftCount4),\(avgShiftCount5),\(avgShiftCount6)"
            saveToFile(content: content2, fileName: fileName2)
            let content3 = "\(n),\(avgCompareCountSize1),\(avgCompareCountSize2),\(avgCompareCountSize3),\(avgCompareCountSize4),\(avgCompareCountSize5),\(avgCompareCountSize6)"
            saveToFile(content: content3, fileName: fileName3)
            let content4 = "\(n),\(avgShiftCountSize1),\(avgShiftCountSize2),\(avgShiftCountSize3),\(avgShiftCountSize4),\(avgShiftCountSize5),\(avgShiftCountSize6)"
            saveToFile(content: content4, fileName: fileName4)  
            let content5 = "\(n),\(avgTime1),\(avgTime2),\(avgTime3),\(avgTime4),\(avgTime5),\(avgTime6)"
            saveToFile(content: content5, fileName: fileName5) 
        }
    }       
}

func test2() {
    let k = [1, 10, 100]
    for i in 0..<3 {
        for n in stride(from: 1000, through: 20000, by: 1000) {
            var totalCompareCount1 = 0
            var totalCompareCount2 = 0
            var totalCompareCount3 = 0
            var totalCompareCount4 = 0
            var totalCompareCount5 = 0
            var totalShiftCount1 = 0
            var totalShiftCount2 = 0
            var totalShiftCount3 = 0
            var totalShiftCount4 = 0  
            var totalShiftCount5 = 0
            var totalTime1: Double = 0
            var totalTime2: Double = 0
            var totalTime3: Double = 0
            var totalTime4: Double = 0
            var totalTime5: Double = 0
            for _ in 0..<k[i] {   
                let randArr = generateRandomKeys(n)
                var randArr1 = randArr
                var randArr2 = randArr
                var randArr3 = randArr
                var randArr4 = randArr
                var randArr5 = randArr
                var compareCount1 = 0
                var compareCount2 = 0
                var compareCount3 = 0
                var compareCount4 = 0
                var compareCount5 = 0
                var shiftCount1 = 0
                var shiftCount2 = 0
                var shiftCount3 = 0
                var shiftCount4 = 0
                var shiftCount5 = 0

                let startTime1 = CACurrentMediaTime()
                mergeSort(&randArr1, 0, randArr1.count-1, &compareCount1, &shiftCount1)
                let endTime1 = CACurrentMediaTime()
                totalTime1 += endTime1 - startTime1

                let startTime2 = CACurrentMediaTime()
                quickSort(&randArr2, 0, randArr2.count-1, &compareCount2, &shiftCount2)
                let endTime2 = CACurrentMediaTime()
                totalTime2 += endTime2 - startTime2

                let startTime3 = CACurrentMediaTime()
                dualPivotQuickSort(&randArr3, 0, randArr3.count-1, &compareCount3, &shiftCount3)
                let endTime3 = CACurrentMediaTime()
                totalTime3 += endTime3 - startTime3

                let startTime4 = CACurrentMediaTime()
                hybridSort(&randArr4, 0, randArr4.count-1, &compareCount4, &shiftCount4)
                let endTime4 = CACurrentMediaTime()
                totalTime4 += endTime4 - startTime4

                let startTime5 = CACurrentMediaTime()
                customSort(randArr5, &compareCount5, &shiftCount5)
                let endTime5 = CACurrentMediaTime()
                totalTime5 += endTime5 - startTime5

                totalCompareCount1 += compareCount1
                totalCompareCount2 += compareCount2
                totalCompareCount3 += compareCount3
                totalCompareCount4 += compareCount4
                totalCompareCount5 += compareCount5

                totalShiftCount1 += shiftCount1
                totalShiftCount2 += shiftCount2
                totalShiftCount3 += shiftCount3
                totalShiftCount4 += shiftCount4
                totalShiftCount5 += shiftCount5
            }
            var avgCompareCount1 = totalCompareCount1/k[i]
            var avgCompareCount2 = totalCompareCount2/k[i]
            var avgCompareCount3 = totalCompareCount3/k[i]
            var avgCompareCount4 = totalCompareCount4/k[i]
            var avgCompareCount5 = totalCompareCount5/k[i]

            var avgShiftCount1 = totalShiftCount1/k[i]
            var avgShiftCount2 = totalShiftCount2/k[i]
            var avgShiftCount3 = totalShiftCount3/k[i]
            var avgShiftCount4 = totalShiftCount4/k[i]
            var avgShiftCount5 = totalShiftCount5/k[i]

            let avgCompareCountSize1 = avgCompareCount1/n
            let avgCompareCountSize2 = avgCompareCount2/n
            let avgCompareCountSize3 = avgCompareCount3/n
            let avgCompareCountSize4 = avgCompareCount4/n
            let avgCompareCountSize5 = avgCompareCount5/n

            let avgShiftCountSize1 = avgShiftCount1/n
            let avgShiftCountSize2 = avgShiftCount2/n
            let avgShiftCountSize3 = avgShiftCount3/n
            let avgShiftCountSize4 = avgShiftCount4/n 
            let avgShiftCountSize5 = avgShiftCount5/n

            let avgTime1 = totalTime1/Double(k[i])
            let avgTime2 = totalTime2/Double(k[i])
            let avgTime3 = totalTime3/Double(k[i])
            let avgTime4 = totalTime4/Double(k[i])
            let avgTime5 = totalTime5/Double(k[i])

            let fileName1 = "avg_comps_b_\(k[i]).txt"
            let fileName2 = "avg_shifts_b_\(k[i]).txt"   
            let fileName3 = "comps_size_b_\(k[i]).txt"
            let fileName4 = "shifts_size_b_\(k[i]).txt"    
            let fileName5 = "avg_time_b_\(k[i]).txt"                   
            let content1 = "\(n),\(avgCompareCount1),\(avgCompareCount2),\(avgCompareCount3),\(avgCompareCount4),\(avgCompareCount5)"
            saveToFile(content: content1, fileName: fileName1)
            let content2 = "\(n),\(avgShiftCount1),\(avgShiftCount2),\(avgShiftCount3),\(avgShiftCount4),\(avgShiftCount5)"
            saveToFile(content: content2, fileName: fileName2)
            let content3 = "\(n),\(avgCompareCountSize1),\(avgCompareCountSize2),\(avgCompareCountSize3),\(avgCompareCountSize4),\(avgCompareCountSize5)"
            saveToFile(content: content3, fileName: fileName3)
            let content4 = "\(n),\(avgShiftCountSize1),\(avgShiftCountSize2),\(avgShiftCountSize3),\(avgShiftCountSize4),\(avgShiftCountSize5)"   
            saveToFile(content: content4, fileName: fileName4)
            let content5 = "\(n),\(avgTime1),\(avgTime2),\(avgTime3),\(avgTime4),\(avgTime5)"
            saveToFile(content: content5, fileName: fileName5) 
        }
    }
}

func test3() {
    let arraySize = 1000
    let trials = 10
    
    for bound in 1..<arraySize {    
        var results1 = [Int]()
        var results2 = [Int]()    
        for j in 1...trials {
            var myArray = generateRandomKeys(arraySize)
            var compareCount = 0
            var shiftCount = 0
            
            testHybridSort(&myArray, 0, arraySize - 1, &compareCount, &shiftCount, bound)
            
            results1.append(compareCount)
            results2.append(shiftCount)
        }
    
        var total_comps = 0
        var total_shifts = 0
        for i in 1..<trials {
            total_comps = total_comps + results1[i] 
            total_shifts = total_shifts + results2[i] 
        }
        var average_comps = total_comps / trials
        var average_shifts = total_shifts / trials

        var content = "\(bound),\(average_comps),\(average_shifts)"
        saveToFile(content: content, fileName: "hybrid_sort.txt")
    }
}

test1()
test2()
test3()
