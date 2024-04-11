import Foundation

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

func presentation() {
    let arr = [8, 16, 32]
    for i in 0..<3 {
        let randArr = generateRandomKeys(arr[i])
        let ascArr = sortKeysAscending(randArr)
        let descArr = sortKeysDescending(randArr)
        print("========================================================================================================")
        print("Rozmiar tablicy: \(arr[i])")
        print()
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        print("Tablica losowych kluczy:")
        printArray(randArr)
        print()
        print("Tablica posortowana rosnąco:")
        printArray(ascArr)
        print()
        print("Tablica posortowana malejąco:")
        printArray(descArr)
        print()
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        print("1. Insertion Sort")
        var randArr1 = randArr
        var compareCount1 = 0
        var shiftCount1 = 0
        print("Wynik sortowania tablicy losowych kluczy:")
        insertionSort(&randArr1, &compareCount1, &shiftCount1)
        printArray(randArr1)
        print()
        print("Liczba wykonanych porównań: \(compareCount1)")
        print("Liczba wykonanych przestawień: \(shiftCount1)")
        print()
        print()        
        var ascArr1 = ascArr
        compareCount1 = 0
        shiftCount1 = 0
        print("Wynik sortowania tablicy posortowanej rosnąco:")
        insertionSort(&ascArr1, &compareCount1, &shiftCount1)
        printArray(ascArr1)
        print()
        print("Liczba wykonanych porównań: \(compareCount1)")
        print("Liczba wykonanych przestawień: \(shiftCount1)")    
        print()
        print()   
        var descArr1 = descArr
        compareCount1 = 0
        shiftCount1 = 0
        print("Wynik sortowania tablicy posortowanej malejąco:")
        insertionSort(&descArr1, &compareCount1, &shiftCount1)
        printArray(descArr1)
        print()
        print("Liczba wykonanych porównań: \(compareCount1)")
        print("Liczba wykonanych przestawień: \(shiftCount1)")    
        print()
        print()            
        print("========================================================================================================")
        print("2. Merge Sort")
        var randArr2 = randArr
        var compareCount2 = 0
        var shiftCount2 = 0
        print("Wynik sortowania tablicy losowych kluczy:")
        mergeSort(&randArr2, 0, randArr2.count - 1, &compareCount2, &shiftCount2)
        printArray(randArr2)
        print()
        print("Liczba wykonanych porównań: \(compareCount2)")
        print("Liczba wykonanych przestawień: \(shiftCount2)")
        print()
        print()        
        var ascArr2 = ascArr
        compareCount2 = 0
        shiftCount2 = 0
        print("Wynik sortowania tablicy posortowanej rosnąco:")
        mergeSort(&ascArr2, 0, randArr2.count - 1, &compareCount2, &shiftCount2)
        printArray(ascArr2)
        print()
        print("Liczba wykonanych porównań: \(compareCount2)")
        print("Liczba wykonanych przestawień: \(shiftCount2)")    
        print()
        print()   
        var descArr2 = descArr
        compareCount2 = 0
        shiftCount2 = 0
        print("Wynik sortowania tablicy posortowanej malejąco:")
        mergeSort(&descArr2, 0, randArr2.count - 1, &compareCount2, &shiftCount2)
        printArray(descArr2)
        print()
        print("Liczba wykonanych porównań: \(compareCount2)")
        print("Liczba wykonanych przestawień: \(shiftCount2)")    
        print()
        print()   
        print("========================================================================================================")
        print("3. Quick Sort")
        var randArr3 = randArr
        var compareCount3 = 0
        var shiftCount3 = 0
        print("Wynik sortowania tablicy losowych kluczy:")
        quickSort(&randArr3, 0, randArr3.count - 1, &compareCount3, &shiftCount3)
        printArray(randArr3)
        print()
        print("Liczba wykonanych porównań: \(compareCount3)")
        print("Liczba wykonanych przestawień: \(shiftCount3)")
        print()
        print()        
        var ascArr3 = ascArr
        compareCount3 = 0
        shiftCount3 = 0
        print("Wynik sortowania tablicy posortowanej rosnąco:")
        quickSort(&ascArr3, 0, randArr3.count - 1, &compareCount3, &shiftCount3)
        printArray(ascArr3)
        print()
        print("Liczba wykonanych porównań: \(compareCount3)")
        print("Liczba wykonanych przestawień: \(shiftCount3)")    
        print()
        print()   
        var descArr3 = descArr
        compareCount3 = 0
        shiftCount3 = 0
        print("Wynik sortowania tablicy posortowanej malejąco:")
        quickSort(&descArr3, 0, randArr3.count - 1, &compareCount3, &shiftCount3)
        printArray(descArr3)
        print()
        print("Liczba wykonanych porównań: \(compareCount3)")
        print("Liczba wykonanych przestawień: \(shiftCount3)")    
        print()
        print()   
        print("========================================================================================================")
        print("4. Dual Pivot Quick Sort")
        var randArr4 = randArr
        var compareCount4 = 0
        var shiftCount4 = 0
        print("Wynik sortowania tablicy losowych kluczy:")
        dualPivotQuickSort(&randArr4, 0, randArr4.count - 1, &compareCount4, &shiftCount4)
        printArray(randArr4)
        print()
        print("Liczba wykonanych porównań: \(compareCount4)")
        print("Liczba wykonanych przestawień: \(shiftCount4)")
        print()
        print()        
        var ascArr4 = ascArr
        compareCount4 = 0
        shiftCount4 = 0
        print("Wynik sortowania tablicy posortowanej rosnąco:")
        dualPivotQuickSort(&ascArr4, 0, randArr4.count - 1, &compareCount4, &shiftCount4)
        printArray(ascArr4)
        print()
        print("Liczba wykonanych porównań: \(compareCount4)")
        print("Liczba wykonanych przestawień: \(shiftCount4)")    
        print()
        print()   
        var descArr4 = descArr
        compareCount4 = 0
        shiftCount4 = 0
        print("Wynik sortowania tablicy posortowanej malejąco:")
        dualPivotQuickSort(&descArr4, 0, randArr4.count - 1, &compareCount4, &shiftCount4)
        printArray(descArr4)
        print()
        print("Liczba wykonanych porównań: \(compareCount4)")
        print("Liczba wykonanych przestawień: \(shiftCount4)")    
        print()
        print()   
        print("========================================================================================================")
        print("5. Hybrid Sort")
        var randArr5 = randArr
        var compareCount5 = 0
        var shiftCount5 = 0
        print("Wynik sortowania tablicy losowych kluczy:")
        hybridSort(&randArr5, 0, randArr5.count - 1, &compareCount5, &shiftCount5)
        printArray(randArr5)
        print()
        print("Liczba wykonanych porównań: \(compareCount5)")
        print("Liczba wykonanych przestawień: \(shiftCount5)")
        print()
        print()        
        var ascArr5 = ascArr
        compareCount5 = 0
        shiftCount5 = 0
        print("Wynik sortowania tablicy posortowanej rosnąco:")
        hybridSort(&ascArr5, 0, randArr5.count - 1, &compareCount5, &shiftCount5)
        printArray(ascArr5)
        print()
        print("Liczba wykonanych porównań: \(compareCount5)")
        print("Liczba wykonanych przestawień: \(shiftCount5)")    
        print()
        print()   
        var descArr5 = descArr
        compareCount5 = 0
        shiftCount5 = 0
        print("Wynik sortowania tablicy posortowanej malejąco:")
        hybridSort(&descArr5, 0, randArr5.count - 1, &compareCount5, &shiftCount5)
        printArray(descArr5)
        print()
        print("Liczba wykonanych porównań: \(compareCount5)")
        print("Liczba wykonanych przestawień: \(shiftCount5)")    
        print()
        print()   
        print("========================================================================================================")
        print("6. Custom Sort")
        var randArr6 = randArr
        var compareCount6 = 0
        var shiftCount6 = 0
        print("Wynik sortowania tablicy losowych kluczy:")
        randArr6 = customSort(randArr6, &compareCount6, &shiftCount6)
        printArray(randArr6)
        print()
        print("Liczba wykonanych porównań: \(compareCount6)")
        print("Liczba wykonanych przestawień: \(shiftCount6)")
        print()
        print()        
        var ascArr6 = ascArr
        compareCount6 = 0
        shiftCount6 = 0
        print("Wynik sortowania tablicy posortowanej rosnąco:")
        ascArr6 = customSort(ascArr6, &compareCount6, &shiftCount6)
        printArray(ascArr6)
        print()
        print("Liczba wykonanych porównań: \(compareCount6)")
        print("Liczba wykonanych przestawień: \(shiftCount6)")    
        print()
        print()   
        var descArr6 = descArr
        compareCount6 = 0
        shiftCount6 = 0
        print("Wynik sortowania tablicy posortowanej malejąco:")
        descArr6 = customSort(descArr6, &compareCount6, &shiftCount6)
        printArray(descArr6)
        print()
        print("Liczba wykonanych porównań: \(compareCount6)")
        print("Liczba wykonanych przestawień: \(shiftCount6)")    
        print()
        print()   
        print("========================================================================================================")

    }
}

presentation()