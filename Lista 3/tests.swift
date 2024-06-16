import Foundation
import QuartzCore

func generateRandomNumber(_ n: Int) -> Int {
    let randomNumber = Int.random(in: 1...n)
    return randomNumber
}

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

func median(_ myArray: [Int]) -> Int {
    if myArray.count % 2 == 1 {
        return myArray[myArray.count / 2]
    } else {
        let midIndex = myArray.count / 2
        return Int((myArray[midIndex - 1] + myArray[midIndex]) / 2)
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
    // x == y
    else if type == "eq" {
        if first == second {
            return true
        } else {
            return false
        }
    }
    else {
        return false
    }
}

func insertionSort(_ arr: [Int], _ compareCount: inout Int, _ shiftCount: inout Int) -> [Int] {
    var myArray = arr
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
    return myArray
}

func partitionModified(_ array: inout [Int], _ start: Int, _ end: Int, _ pivot: Int, _ shiftCount: inout Int, _ compareCount: inout Int) -> Int {
    var iterator = start
    var pivotPos = 0

    while iterator <= end {
        if compare("eq", array[iterator], pivot, &compareCount) {
            pivotPos = iterator
            break
        }
        iterator += 1
    }

    swap(&array, pivotPos, end, &shiftCount)

    var newPivotPos = start

    iterator = start

    while iterator <= (end - 1) {
        if compare("le", array[iterator], pivot, &compareCount) {
            swap(&array, newPivotPos, iterator, &shiftCount)
            newPivotPos += 1
        }
        iterator += 1
    }

    swap(&array, newPivotPos, end, &shiftCount)
    return newPivotPos
}

func select(_ array: inout [Int], _ start: Int, _ end: Int, _ k: Int, _ p: Int, _ shiftCount: inout Int, _ compareCount: inout Int) -> Int? {
    var listOfList: [[Int]] = []

    for i in stride(from: start, through: end, by: p) {
        if i + p >= end {
            listOfList.append(Array(array[i...end]))
        } else {
            listOfList.append(Array(array[i...(i + (p - 1))]))
        }
    }

    var medians: [Int] = []

    for lis in listOfList {
        let lis = insertionSort(lis, &compareCount, &shiftCount)
        medians.append(median(lis))
    }

    let medsLength = medians.count

    var pivot: Int

    if medsLength == 1 {
        pivot = medians[0]
    } else {
        if let result = select(&medians, 0, medsLength - 1, medsLength / 2, p, &shiftCount, &compareCount) {
            pivot = result
        } else {
            return nil
        }
    }

    let pos = partitionModified(&array, start, end, pivot, &shiftCount, &compareCount)

    if (pos - start) == k - 1 {
        return array[pos]
    } else if (pos - start) > (k - 1) {
        return select(&array, start, pos - 1, k, p, &shiftCount, &compareCount)
    } else {
        return select(&array, pos + 1, end, (k - pos + start - 1), p, &shiftCount, &compareCount)
    }
}

func partition(_ array: inout [Int], _ begin: Int, _ end: Int, _ shiftCount: inout Int, _ compareCount: inout Int) -> Int {
    let pivot = array[begin]
    var j = begin
    for i in (begin + 1)...end {
        if compare("lt", array[i], pivot, &compareCount) {
            j += 1
            swap(&array, j, i, &shiftCount)
        }
    }
    swap(&array, begin, j, &shiftCount)
    return j + 1
}


func randomizedPartition(_ array: inout [Int], _ begin: Int, _ end: Int, _ shiftCount: inout Int, _ compareCount: inout Int) -> Int {
    let tmp = Int.random(in: begin..<end)
    swap(&array, begin, tmp, &shiftCount)
    return partition(&array, begin, end, &shiftCount, &compareCount)
}

func randomizedSelect(_ array: inout [Int], _ begin: Int, _ end: Int, _ k: Int, _ shiftCount: inout Int, _ compareCount: inout Int) -> Int {
    if begin == end {
        return array[begin]
    }
    let currentIndex = randomizedPartition(&array, begin, end, &shiftCount, &compareCount)
    let position = currentIndex - begin
    if k == position {
        return array[currentIndex - 1]
    } else if compare("lt", position, k, &compareCount) {
        return randomizedSelect(&array, currentIndex, end, k - position, &shiftCount, &compareCount)
    } else {
        return randomizedSelect(&array, begin, currentIndex - 2, k, &shiftCount, &compareCount)
    }
}

func binarySearch(_ array: inout [Int], _ left: Int, _ right: Int, _ element: Int, _ compareCount: inout Int) -> Int {
    if right >= left {
        let mid = left + (right - left) / 2
        if compare("eq", array[mid], element, &compareCount) {
            return mid
        } else if compare("gt", array[mid], element, &compareCount) {
            return binarySearch(&array, left, mid - 1, element, &compareCount)
        } else {
            return binarySearch(&array, mid + 1, right, element, &compareCount)
        }
    } else {
        return -1
    }
}

func partitionMod(_ array: inout [Int], _ start: Int, _ end: Int, _ pivot: Int, _ shiftCount: inout Int, _ compareCount: inout Int) -> (Int, Int) {
    var low = start
    var high = end

    var i = start
    while i <= high {
        compareCount += 1
        if array[i] < pivot {
            swap(&array, i, low, &shiftCount)
            low += 1
            i += 1
        } else if array[i] > pivot {
            swap(&array, i, high, &shiftCount)
            high -= 1
        } else {
            i += 1
        }
    }

    return (low, high)
}

func quickSelectSort(_ array: inout [Int], _ start: Int, _ end: Int, _ shiftCount: inout Int, _ compareCount: inout Int) {
    if start < end {
        let k = end - start + 1
        let roundedK = Int(floor(Double(k) / 2))
        let pivot = select(&array, start, end, roundedK, 5, &shiftCount, &compareCount)!
        let (left, right) = partitionMod(&array, start, end, pivot, &shiftCount, &compareCount)
        quickSelectSort(&array, start, left - 1, &shiftCount, &compareCount)
        quickSelectSort(&array, right + 1, end, &shiftCount, &compareCount)
    }
}

func dualPivotPartitionMod(_ array: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) -> (Int, Int) {
    let size = end - start + 1
    let roundedK1 = Int(floor(Double(size) / 3)) + 1
    let roundedK2 = Int(floor(2*(Double(size) / 3))) + 1
    var p = select(&array, start, end, roundedK1, 5, &shiftCount, &compareCount)!
    var q = select(&array, start, end, roundedK2, 5, &shiftCount, &compareCount)!
    if compare("lt", q, p, &compareCount) {
        let temp = p
        p = q
        q = temp
    }
    
    var j = start + 1
    var k = j
    var g = end - 1
    
    while k <= g {
        if compare("lt", array[k], p, &compareCount) {
            swap(&array, k, j, &shiftCount)
            j += 1
        } else if compare("ge", array[k], q, &compareCount) {
            while compare("gt", array[g], q, &compareCount) && k < g {
                g -= 1
            }
            swap(&array, k, g, &shiftCount)
            g -= 1
            if compare("lt", array[k], p, &compareCount) {
                swap(&array, k, j, &shiftCount)
                j += 1
            }
        }
        k += 1
    }
    
    j -= 1
    g += 1   
    
    return (j, g)
}

func dualPivotQuickSelectSort(_ myArray: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) {
    if start < end {
        let (leftPivot, rightPivot) = dualPivotPartitionMod(&myArray, start, end, &compareCount, &shiftCount)
        dualPivotQuickSelectSort(&myArray, start, leftPivot - 1, &compareCount, &shiftCount)
        dualPivotQuickSelectSort(&myArray, leftPivot + 1, rightPivot - 1, &compareCount, &shiftCount)
        dualPivotQuickSelectSort(&myArray, rightPivot + 1, end, &compareCount, &shiftCount)
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

func saveToFile(content: String, fileName: String) {
    let folderName = "results6"
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
    let k = 50
    for n in stride(from: 100, through: 50000, by: 100) {
        var totalCompareCount1 = 0
        var totalCompareCount2 = 0
        var totalShiftCount1 = 0
        var totalShiftCount2 = 0 
        var totalTime1: Double = 0
        var totalTime2: Double = 0
        for _ in 0..<k {   
            let randArr = generateRandomKeys(n)
            let randK = generateRandomNumber(n)
            var randArr1 = randArr
            var randArr2 = randArr
            var compareCount1 = 0
            var compareCount2 = 0
            var shiftCount1 = 0
            var shiftCount2 = 0

            let startTime1 = CACurrentMediaTime()
            _ = randomizedSelect(&randArr1, 0, randArr1.count-1, randK, &shiftCount1, &compareCount1)
            let endTime1 = CACurrentMediaTime()
            totalTime1 += endTime1 - startTime1

            let startTime2 = CACurrentMediaTime()
            _ = select(&randArr2, 0, randArr2.count-1, randK, 5, &shiftCount2, &compareCount2)
            let endTime2 = CACurrentMediaTime()
            totalTime2 += endTime2 - startTime2

            totalCompareCount1 += compareCount1
            totalCompareCount2 += compareCount2
            totalShiftCount1 += shiftCount1
            totalShiftCount2 += shiftCount2
        }

        let avgCompareCount1 = totalCompareCount1/k
        let avgCompareCount2 = totalCompareCount2/k

        let avgShiftCount1 = totalShiftCount1/k
        let avgShiftCount2 = totalShiftCount2/k

        let avgCompareCountSize1 = avgCompareCount1/n
        let avgCompareCountSize2 = avgCompareCount2/n

        let avgShiftCountSize1 = avgShiftCount1/n
        let avgShiftCountSize2 = avgShiftCount2/n

        let avgTime1 = totalTime1/Double(k)
        let avgTime2 = totalTime2/Double(k)
        
        let content1 = "\(n),\(avgCompareCount1),\(avgCompareCount2)"
        let fileName1 = "avg_comps_\(k).txt"
        saveToFile(content: content1, fileName: fileName1)

        let content2 = "\(n),\(avgShiftCount1),\(avgShiftCount2)"
        let fileName2 = "avg_shifts_\(k).txt"
        saveToFile(content: content2, fileName: fileName2)

        let content3 = "\(n),\(avgCompareCountSize1),\(avgCompareCountSize2)"
        let fileName3 = "avg_comps_size_\(k).txt"
        saveToFile(content: content3, fileName: fileName3)

        let content4 = "\(n),\(avgShiftCountSize1),\(avgShiftCountSize2)"
        let fileName4 = "avg_shifts_size_\(k).txt"
        saveToFile(content: content4, fileName: fileName4)

        let content5 = "\(n),\(avgTime1),\(avgTime2)"
        let fileName5 = "avg_time_\(k).txt"
        saveToFile(content: content5, fileName: fileName5)
    }
}

func test2() {
    let k = 50
    for n in stride(from: 100, through: 50000, by: 100) {
        var totalCompareCount1 = 0
        var totalCompareCount2 = 0
        var totalCompareCount3 = 0
        var totalCompareCount4 = 0

        var totalShiftCount1 = 0
        var totalShiftCount2 = 0 
        var totalShiftCount3 = 0
        var totalShiftCount4 = 0 

        var totalTime1: Double = 0
        var totalTime2: Double = 0
        var totalTime3: Double = 0
        var totalTime4: Double = 0
        for _ in 0..<k {
            let randArr = generateRandomKeys(n)
            let randK = generateRandomNumber(n)
            var randArr1 = randArr
            var randArr2 = randArr
            var randArr3 = randArr
            var randArr4 = randArr

            var compareCount1 = 0
            var compareCount2 = 0
            var compareCount3 = 0
            var compareCount4 = 0

            var shiftCount1 = 0
            var shiftCount2 = 0
            var shiftCount3 = 0
            var shiftCount4 = 0

            let startTime1 = CACurrentMediaTime()
            _ = select(&randArr1, 0, randArr1.count-1, randK, 3, &shiftCount1, &compareCount1)
            let endTime1 = CACurrentMediaTime()
            totalTime1 += endTime1 - startTime1
            
            let startTime2 = CACurrentMediaTime()
            _ = select(&randArr2, 0, randArr2.count-1, randK, 5, &shiftCount2, &compareCount2)
            let endTime2 = CACurrentMediaTime()
            totalTime2 += endTime2 - startTime2
            
            let startTime3 = CACurrentMediaTime()
            _ = select(&randArr3, 0, randArr3.count-1, randK, 7, &shiftCount3, &compareCount3)
            let endTime3 = CACurrentMediaTime()
            totalTime3 += endTime3 - startTime3
            
            let startTime4 = CACurrentMediaTime()
            _ = select(&randArr4, 0, randArr4.count-1, randK, 9, &shiftCount4, &compareCount4)
            let endTime4 = CACurrentMediaTime()
            totalTime4 += endTime4 - startTime4
            
            totalCompareCount1 += compareCount1
            totalCompareCount2 += compareCount2
            totalCompareCount3 += compareCount3
            totalCompareCount4 += compareCount4

            totalShiftCount1 += shiftCount1
            totalShiftCount2 += shiftCount2
            totalShiftCount3 += shiftCount3
            totalShiftCount4 += shiftCount4
        }

        let avgCompareCount1 = totalCompareCount1/k
        let avgCompareCount2 = totalCompareCount2/k
        let avgCompareCount3 = totalCompareCount3/k
        let avgCompareCount4 = totalCompareCount4/k

        let avgShiftCount1 = totalShiftCount1/k
        let avgShiftCount2 = totalShiftCount2/k
        let avgShiftCount3 = totalShiftCount3/k
        let avgShiftCount4 = totalShiftCount4/k

        let avgCompareCountSize1 = avgCompareCount1/n
        let avgCompareCountSize2 = avgCompareCount2/n
        let avgCompareCountSize3 = avgCompareCount3/n
        let avgCompareCountSize4 = avgCompareCount4/n

        let avgShiftCountSize1 = avgShiftCount1/n
        let avgShiftCountSize2 = avgShiftCount2/n
        let avgShiftCountSize3 = avgShiftCount3/n
        let avgShiftCountSize4 = avgShiftCount4/n

        let avgTime1 = totalTime1/Double(k)
        let avgTime2 = totalTime2/Double(k)
        let avgTime3 = totalTime3/Double(k)
        let avgTime4 = totalTime4/Double(k)
        
        let content1 = "\(n),\(avgCompareCount1),\(avgCompareCount2),\(avgCompareCount3),\(avgCompareCount4)"
        let fileName1 = "avg_comps.txt"
        saveToFile(content: content1, fileName: fileName1)

        let content2 = "\(n),\(avgShiftCount1),\(avgShiftCount2),\(avgShiftCount3),\(avgShiftCount4)"
        let fileName2 = "avg_shifts.txt"
        saveToFile(content: content2, fileName: fileName2)

        let content3 = "\(n),\(avgCompareCountSize1),\(avgCompareCountSize2),\(avgCompareCountSize3),\(avgCompareCountSize4)"
        let fileName3 = "avg_comps_size.txt"
        saveToFile(content: content3, fileName: fileName3)

        let content4 = "\(n),\(avgShiftCountSize1),\(avgShiftCountSize2),\(avgShiftCountSize3),\(avgShiftCountSize4)"
        let fileName4 = "avg_shifts_size.txt"
        saveToFile(content: content4, fileName: fileName4)

        let content5 = "\(n),\(avgTime1),\(avgTime2),\(avgTime3),\(avgTime4)"
        let fileName5 = "avg_time.txt"
        saveToFile(content: content5, fileName: fileName5)
    }
}

func test3() {
    let k = 50
    for n in stride(from: 1000, through: 100000, by: 1000) {
        var totalCompareCount1 = 0
        var totalCompareCount2 = 0
        var totalCompareCount3 = 0
        var totalCompareCount4 = 0

        var totalTime1: Double = 0
        var totalTime2: Double = 0
        var totalTime3: Double = 0
        var totalTime4: Double = 0
        for _ in 0..<k {
            let randArr = generateRandomKeys(n)
            let arr = randArr.sorted()
            var arr1 = arr
            var arr2 = arr
            var arr3 = arr
            var arr4 = arr

            var compareCount1 = 0
            var compareCount2 = 0
            var compareCount3 = 0
            var compareCount4 = 0

            let index1 = arr1.count * 2 / 10
            let index2 = arr2.count / 2
            let index3 = arr3.count * 8 / 10
            let elem4 = n*2+10

            let startTime1 = CACurrentMediaTime()
            _ = binarySearch(&arr1, 0, arr1.count-1, arr1[index1], &compareCount1)
            let endTime1 = CACurrentMediaTime()
            totalTime1 += endTime1 - startTime1
            
            let startTime2 = CACurrentMediaTime()
            _ = binarySearch(&arr2, 0, arr2.count-1, arr2[index2], &compareCount2)
            let endTime2 = CACurrentMediaTime()
            totalTime2 += endTime2 - startTime2
            
            let startTime3 = CACurrentMediaTime()
            _ = binarySearch(&arr3, 0, arr3.count-1, arr3[index3], &compareCount3)
            let endTime3 = CACurrentMediaTime()
            totalTime3 += endTime3 - startTime3

            let startTime4 = CACurrentMediaTime()
            _ = binarySearch(&arr4, 0, arr4.count-1, elem4, &compareCount4)
            let endTime4 = CACurrentMediaTime()
            totalTime4 += endTime4 - startTime4
            
            totalCompareCount1 += compareCount1
            totalCompareCount2 += compareCount2
            totalCompareCount3 += compareCount3
            totalCompareCount4 += compareCount4
        }

        let avgCompareCount1 = totalCompareCount1/k
        let avgCompareCount2 = totalCompareCount2/k
        let avgCompareCount3 = totalCompareCount3/k
        let avgCompareCount4 = totalCompareCount4/k

        let avgTime1 = totalTime1/Double(k)
        let avgTime2 = totalTime2/Double(k)
        let avgTime3 = totalTime3/Double(k)
        let avgTime4 = totalTime4/Double(k)
        
        let content1 = "\(n),\(avgCompareCount1),\(avgCompareCount2),\(avgCompareCount3),\(avgCompareCount4)"
        let fileName1 = "avg_comps.txt"
        saveToFile(content: content1, fileName: fileName1)

        let content2 = "\(n),\(avgTime1),\(avgTime2),\(avgTime3),\(avgTime4)"
        let fileName2 = "avg_time.txt"
        saveToFile(content: content2, fileName: fileName2)
    }
}

func test4() {
    let k = 10
    for n in stride(from: 100, through: 10000, by: 100) {
        var totalCompareCount1 = 0
        var totalCompareCount2 = 0
        var totalCompareCount3 = 0
        var totalCompareCount4 = 0

        var totalShiftCount1 = 0
        var totalShiftCount2 = 0
        var totalShiftCount3 = 0
        var totalShiftCount4 = 0

        var totalTime1: Double = 0
        var totalTime2: Double = 0
        var totalTime3: Double = 0
        var totalTime4: Double = 0
        for _ in 0..<k {   
            let randArr = generateRandomKeys(n)
            var randArr1 = randArr
            var randArr2 = randArr
            var randArr3 = randArr
            var randArr4 = randArr

            var compareCount1 = 0
            var compareCount2 = 0
            var compareCount3 = 0
            var compareCount4 = 0

            var shiftCount1 = 0
            var shiftCount2 = 0
            var shiftCount3 = 0
            var shiftCount4 = 0

            let startTime1 = CACurrentMediaTime()
            quickSort(&randArr1, 0, randArr2.count-1, &compareCount1, &shiftCount1)
            let endTime1 = CACurrentMediaTime()
            totalTime1 += endTime1 - startTime1

            let startTime2 = CACurrentMediaTime()
            quickSelectSort(&randArr2, 0, randArr2.count-1, &compareCount2, &shiftCount2)
            let endTime2 = CACurrentMediaTime()
            totalTime2 += endTime2 - startTime2

            let startTime3 = CACurrentMediaTime()
            dualPivotQuickSort(&randArr3, 0, randArr3.count-1, &compareCount3, &shiftCount3)
            let endTime3 = CACurrentMediaTime()
            totalTime3 += endTime3 - startTime3

            let startTime4 = CACurrentMediaTime()
            dualPivotQuickSelectSort(&randArr4, 0, randArr4.count-1, &compareCount4, &shiftCount4)
            let endTime4 = CACurrentMediaTime()
            totalTime4 += endTime4 - startTime4

            totalCompareCount1 += compareCount1
            totalCompareCount2 += compareCount2
            totalCompareCount3 += compareCount3
            totalCompareCount4 += compareCount4

            totalShiftCount1 += shiftCount1
            totalShiftCount2 += shiftCount2
            totalShiftCount3 += shiftCount3
            totalShiftCount4 += shiftCount4
        }
        let avgCompareCount1 = totalCompareCount1/k
        let avgCompareCount2 = totalCompareCount2/k
        let avgCompareCount3 = totalCompareCount3/k
        let avgCompareCount4 = totalCompareCount4/k

        let avgShiftCount1 = totalShiftCount1/k
        let avgShiftCount2 = totalShiftCount2/k
        let avgShiftCount3 = totalShiftCount3/k
        let avgShiftCount4 = totalShiftCount4/k

        let avgCompareCountSize1 = avgCompareCount1/n
        let avgCompareCountSize2 = avgCompareCount2/n
        let avgCompareCountSize3 = avgCompareCount3/n
        let avgCompareCountSize4 = avgCompareCount4/n

        let avgShiftCountSize1 = avgShiftCount1/n
        let avgShiftCountSize2 = avgShiftCount2/n
        let avgShiftCountSize3 = avgShiftCount3/n
        let avgShiftCountSize4 = avgShiftCount4/n

        let avgTime1 = totalTime1/Double(k)
        let avgTime2 = totalTime2/Double(k)
        let avgTime3 = totalTime3/Double(k)
        let avgTime4 = totalTime4/Double(k)

        let fileName1 = "avg_comps_\(k).txt"
        let fileName2 = "avg_shifts_\(k).txt"   
        let fileName3 = "comps_size_\(k).txt"
        let fileName4 = "shifts_size_\(k).txt"   
        let fileName5 = "avg_time_\(k).txt"    

        let content1 = "\(n),\(avgCompareCount1),\(avgCompareCount2),\(avgCompareCount3),\(avgCompareCount4)"
        saveToFile(content: content1, fileName: fileName1)  
        let content2 = "\(n),\(avgShiftCount1),\(avgShiftCount2),\(avgShiftCount3),\(avgShiftCount4)"
        saveToFile(content: content2, fileName: fileName2)
        let content3 = "\(n),\(avgCompareCountSize1),\(avgCompareCountSize2),\(avgCompareCountSize3),\(avgCompareCountSize4)"
        saveToFile(content: content3, fileName: fileName3)
        let content4 = "\(n),\(avgShiftCountSize1),\(avgShiftCountSize2),\(avgShiftCountSize3),\(avgShiftCountSize4)"
        saveToFile(content: content4, fileName: fileName4)  
        let content5 = "\(n),\(avgTime1),\(avgTime2),\(avgTime3),\(avgTime4)"
        saveToFile(content: content5, fileName: fileName5) 
    } 
}

func test5() {
    let k = 10
    for n in stride(from: 100, through: 10000, by: 100) {
        var totalCompareCount1 = 0
        var totalCompareCount2 = 0
        var totalCompareCount3 = 0
        var totalCompareCount4 = 0

        var totalShiftCount1 = 0
        var totalShiftCount2 = 0
        var totalShiftCount3 = 0
        var totalShiftCount4 = 0

        var totalTime1: Double = 0
        var totalTime2: Double = 0
        var totalTime3: Double = 0
        var totalTime4: Double = 0
        for _ in 0..<k {   
            var randArr = generateRandomKeys(n)
            let descArr = sortKeysDescending(randArr)
            var descArr1 = descArr
            var descArr2 = descArr
            var descArr3 = descArr
            var descArr4 = descArr

            var compareCount1 = 0
            var compareCount2 = 0
            var compareCount3 = 0
            var compareCount4 = 0

            var shiftCount1 = 0
            var shiftCount2 = 0
            var shiftCount3 = 0
            var shiftCount4 = 0

            let startTime1 = CACurrentMediaTime()
            quickSort(&descArr1, 0, descArr1.count-1, &compareCount1, &shiftCount1)
            let endTime1 = CACurrentMediaTime()
            totalTime1 += endTime1 - startTime1

            let startTime2 = CACurrentMediaTime()
            quickSelectSort(&descArr2, 0, descArr2.count-1, &compareCount2, &shiftCount2)
            let endTime2 = CACurrentMediaTime()
            totalTime2 += endTime2 - startTime2

            let startTime3 = CACurrentMediaTime()
            dualPivotQuickSort(&descArr3, 0, descArr3.count-1, &compareCount3, &shiftCount3)
            let endTime3 = CACurrentMediaTime()
            totalTime3 += endTime3 - startTime3

            let startTime4 = CACurrentMediaTime()
            dualPivotQuickSelectSort(&descArr4, 0, descArr4.count-1, &compareCount4, &shiftCount4)
            let endTime4 = CACurrentMediaTime()
            totalTime4 += endTime4 - startTime4

            totalCompareCount1 += compareCount1
            totalCompareCount2 += compareCount2
            totalCompareCount3 += compareCount3
            totalCompareCount4 += compareCount4

            totalShiftCount1 += shiftCount1
            totalShiftCount2 += shiftCount2
            totalShiftCount3 += shiftCount3
            totalShiftCount4 += shiftCount4
        }
        let avgCompareCount1 = totalCompareCount1/k
        let avgCompareCount2 = totalCompareCount2/k
        let avgCompareCount3 = totalCompareCount3/k
        let avgCompareCount4 = totalCompareCount4/k

        let avgShiftCount1 = totalShiftCount1/k
        let avgShiftCount2 = totalShiftCount2/k
        let avgShiftCount3 = totalShiftCount3/k
        let avgShiftCount4 = totalShiftCount4/k

        let avgCompareCountSize1 = avgCompareCount1/n
        let avgCompareCountSize2 = avgCompareCount2/n
        let avgCompareCountSize3 = avgCompareCount3/n
        let avgCompareCountSize4 = avgCompareCount4/n

        let avgShiftCountSize1 = avgShiftCount1/n
        let avgShiftCountSize2 = avgShiftCount2/n
        let avgShiftCountSize3 = avgShiftCount3/n
        let avgShiftCountSize4 = avgShiftCount4/n

        let avgTime1 = totalTime1/Double(k)
        let avgTime2 = totalTime2/Double(k)
        let avgTime3 = totalTime3/Double(k)
        let avgTime4 = totalTime4/Double(k)

        let fileName1 = "avg_comps_\(k).txt"
        let fileName2 = "avg_shifts_\(k).txt"   
        let fileName3 = "comps_size_\(k).txt"
        let fileName4 = "shifts_size_\(k).txt"   
        let fileName5 = "avg_time_\(k).txt"    

        let content1 = "\(n),\(avgCompareCount1),\(avgCompareCount2),\(avgCompareCount3),\(avgCompareCount4)"
        saveToFile(content: content1, fileName: fileName1)  
        let content2 = "\(n),\(avgShiftCount1),\(avgShiftCount2),\(avgShiftCount3),\(avgShiftCount4)"
        saveToFile(content: content2, fileName: fileName2)
        let content3 = "\(n),\(avgCompareCountSize1),\(avgCompareCountSize2),\(avgCompareCountSize3),\(avgCompareCountSize4)"
        saveToFile(content: content3, fileName: fileName3)
        let content4 = "\(n),\(avgShiftCountSize1),\(avgShiftCountSize2),\(avgShiftCountSize3),\(avgShiftCountSize4)"
        saveToFile(content: content4, fileName: fileName4)  
        let content5 = "\(n),\(avgTime1),\(avgTime2),\(avgTime3),\(avgTime4)"
        saveToFile(content: content5, fileName: fileName5) 
    } 
}

func test6() {
    let k = 50
    for n in stride(from: 1000, through: 100000, by: 1000) {
        var totalCompareCount1 = 0

        var totalTime1: Double = 0
        for _ in 0..<k {
            let randArr = generateRandomKeys(n)
            let arr = randArr.sorted()
            var arr1 = arr

            var compareCount1 = 0

            let index1 = generateRandomNumber(n-1)

            let startTime1 = CACurrentMediaTime()
            _ = binarySearch(&arr1, 0, arr1.count-1, arr1[index1], &compareCount1)
            let endTime1 = CACurrentMediaTime()
            totalTime1 += endTime1 - startTime1      
            totalCompareCount1 += compareCount1
        }

        let avgCompareCount1 = totalCompareCount1/k

        let avgTime1 = totalTime1/Double(k)
        
        let content1 = "\(n),\(avgCompareCount1)"
        let fileName1 = "avg_comps.txt"
        saveToFile(content: content1, fileName: fileName1)

        let content2 = "\(n),\(avgTime1)"
        let fileName2 = "avg_time.txt"
        saveToFile(content: content2, fileName: fileName2)
    }
}

//test1()
//test2()
//test3()
//test4()
//test5()
test6()