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


func main() {
    while(true) {
        print("Wybierz interesujący Cię algorytm sortowania!")
        print()
        print("1. Insertion Sort")
        print("2. Merge Sort")
        print("3. Quick Sort")
        print("4. Dual Pivot Quick Sort")
        print("5. Hybrid Sort")
        print("6. Custom Sort")
        print("7. Zamknij program")
        if let input1 = readLine(), let number1 = Int(input1) {
            switch number1 {
                case 1:
                    print("Wybrałeś/aś Insertion Sort'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        print("Wybierz rodzaj generowanej tablicy")
                        print("1. Losowy ciąg")
                        print("2. Ciąg posortowany malejąco")
                        print("3. Ciąg posortowany rosnąco")
                        if let input3 = readLine(), let number3 = Int(input3) {
                            if number3 == 1 {
                                myArray = generateRandomKeys(number2)
                            }
                            else if number3 == 2 {
                                myArray = sortKeysDescending(generateRandomKeys(number2))
                            }
                            else if number3 == 3 {
                                myArray = sortKeysAscending(generateRandomKeys(number2))
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        insertionSort(&myArray, &compareCount, &shiftCount)
                        if number2 < 40 {
                            print("Wygenerowana tablica:")
                            printArray(arr)
                            print()
                            print("Posortowana tablica:")
                            printArray(myArray)
                            print()
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        } else {
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        }
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }

                case 2:
                    print("Wybrałeś/aś Merge Sort'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        print("Wybierz rodzaj generowanej tablicy")
                        print("1. Losowy ciąg")
                        print("2. Ciąg posortowany malejąco")
                        print("3. Ciąg posortowany rosnąco")
                        if let input3 = readLine(), let number3 = Int(input3) {
                            if number3 == 1 {
                                myArray = generateRandomKeys(number2)
                            }
                            else if number3 == 2 {
                                myArray = sortKeysDescending(generateRandomKeys(number2))
                            }
                            else if number3 == 3 {
                                myArray = sortKeysAscending(generateRandomKeys(number2))
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        mergeSort(&myArray, 0, myArray.count-1, &compareCount, &shiftCount)
                        if number2 < 40 {
                            print("Wygenerowana tablica:")
                            printArray(arr)
                            print()
                            print("Posortowana tablica:")
                            printArray(myArray)
                            print()
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        } else {
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        }
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }

                case 3:
                    print("Wybrałeś/aś Quick Sort'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        print("Wybierz rodzaj generowanej tablicy")
                        print("1. Losowy ciąg")
                        print("2. Ciąg posortowany malejąco")
                        print("3. Ciąg posortowany rosnąco")
                        if let input3 = readLine(), let number3 = Int(input3) {
                            if number3 == 1 {
                                myArray = generateRandomKeys(number2)
                            }
                            else if number3 == 2 {
                                myArray = sortKeysDescending(generateRandomKeys(number2))
                            }
                            else if number3 == 3 {
                                myArray = sortKeysAscending(generateRandomKeys(number2))
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        quickSort(&myArray, 0, myArray.count-1, &compareCount, &shiftCount)
                        if number2 < 40 {
                            print("Wygenerowana tablica:")
                            printArray(arr)
                            print()
                            print("Posortowana tablica:")
                            printArray(myArray)
                            print()
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        } else {
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        }
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }

                case 4:
                    print("Wybrałeś/aś Dual Pivot Quick Sort'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        print("Wybierz rodzaj generowanej tablicy")
                        print("1. Losowy ciąg")
                        print("2. Ciąg posortowany malejąco")
                        print("3. Ciąg posortowany rosnąco")
                        if let input3 = readLine(), let number3 = Int(input3) {
                            if number3 == 1 {
                                myArray = generateRandomKeys(number2)
                            }
                            else if number3 == 2 {
                                myArray = sortKeysDescending(generateRandomKeys(number2))
                            }
                            else if number3 == 3 {
                                myArray = sortKeysAscending(generateRandomKeys(number2))
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        dualPivotQuickSort(&myArray, 0, myArray.count-1, &compareCount, &shiftCount)
                        if number2 < 40 {
                            print("Wygenerowana tablica:")
                            printArray(arr)
                            print()
                            print("Posortowana tablica:")
                            printArray(myArray)
                            print()
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        } else {
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        }
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }

                case 5:
                    print("Wybrałeś/aś Hybrid Sort'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        print("Wybierz rodzaj generowanej tablicy")
                        print("1. Losowy ciąg")
                        print("2. Ciąg posortowany malejąco")
                        print("3. Ciąg posortowany rosnąco")
                        if let input3 = readLine(), let number3 = Int(input3) {
                            if number3 == 1 {
                                myArray = generateRandomKeys(number2)
                            }
                            else if number3 == 2 {
                                myArray = sortKeysDescending(generateRandomKeys(number2))
                            }
                            else if number3 == 3 {
                                myArray = sortKeysAscending(generateRandomKeys(number2))
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        hybridSort(&myArray, 0, myArray.count-1, &compareCount, &shiftCount)
                        if number2 < 40 {
                            print("Wygenerowana tablica:")
                            printArray(arr)
                            print()
                            print("Posortowana tablica:")
                            printArray(myArray)
                            print()
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        } else {
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        }
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }

                case 6:
                    print("Wybrałeś/aś Custom Sort'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        print("Wybierz rodzaj generowanej tablicy")
                        print("1. Losowy ciąg")
                        print("2. Ciąg posortowany malejąco")
                        print("3. Ciąg posortowany rosnąco")
                        if let input3 = readLine(), let number3 = Int(input3) {
                            if number3 == 1 {
                                myArray = generateRandomKeys(number2)
                            }
                            else if number3 == 2 {
                                myArray = sortKeysDescending(generateRandomKeys(number2))
                            }
                            else if number3 == 3 {
                                myArray = sortKeysAscending(generateRandomKeys(number2))
                            }
                        } else {
                            print("Nieprawidłowe dane wejściowe.")
                            print()
                        }
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        myArray = customSort(myArray, &compareCount, &shiftCount)
                        if number2 < 40 {
                            print("Wygenerowana tablica:")
                            printArray(arr)
                            print()
                            print("Posortowana tablica:")
                            printArray(myArray)
                            print()
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        } else {
                            print("Liczba wykonanych porównań: \(compareCount)")
                            print("Liczba wykonanych przestawień: \(shiftCount)")
                            checkIfSorted(myArray)
                            print()
                        }
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }

                case 7:
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