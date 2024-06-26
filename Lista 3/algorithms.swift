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

func select(_ array: inout [Int], _ start: Int, _ end: Int, _ k: Int, _ shiftCount: inout Int, _ compareCount: inout Int) -> Int? {
    var listOfList: [[Int]] = []

    for i in stride(from: start, through: end, by: 5) {
        if i + 5 >= end {
            listOfList.append(Array(array[i...end]))
        } else {
            listOfList.append(Array(array[i...(i + 4)]))
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
        if let result = select(&medians, 0, medsLength - 1, medsLength / 2, &shiftCount, &compareCount) {
            pivot = result
        } else {
            return nil
        }
    }

    let pos = partitionModified(&array, start, end, pivot, &shiftCount, &compareCount)

    if (pos - start) == k - 1 {
        return array[pos]
    } else if (pos - start) > (k - 1) {
        return select(&array, start, pos - 1, k, &shiftCount, &compareCount)
    } else {
        return select(&array, pos + 1, end, (k - pos + start - 1), &shiftCount, &compareCount)
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

func binarySearch(_ array: inout [Int], _ left: Int, _ right: Int, _ element: Int, _ shiftCount: inout Int, _ compareCount: inout Int) -> Int {
    if right >= left {
        let mid = left + (right - left) / 2
        if array[mid] == element {
            return mid
        } else if array[mid] > element {
            return binarySearch(&array, left, mid - 1, element, &shiftCount, &compareCount)
        } else {
            return binarySearch(&array, mid + 1, right, element, &shiftCount, &compareCount)
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
        let pivot = select(&array, start, end, roundedK, &shiftCount, &compareCount)!
        let (left, right) = partitionMod(&array, start, end, pivot, &shiftCount, &compareCount)
        quickSelectSort(&array, start, left - 1, &shiftCount, &compareCount)
        quickSelectSort(&array, right + 1, end, &shiftCount, &compareCount)
    }
}

func dualPivotPartitionMod(_ array: inout [Int], _ start: Int, _ end: Int, _ compareCount: inout Int, _ shiftCount: inout Int) -> (Int, Int) {
    let size = end - start + 1
    let roundedK1 = Int(floor(Double(size) / 3)) + 1
    let roundedK2 = Int(floor(2*(Double(size) / 3))) + 1
    var p = select(&array, start, end, roundedK1, &shiftCount, &compareCount)!
    var q = select(&array, start, end, roundedK2, &shiftCount, &compareCount)!
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

func main() {
    while(true) {
        print("Wybierz interesujący Cię algorytm wyszukiwania/sortowania!")
        print()
        print("1. Select")
        print("2. Randomized Select")
        print("3. Binary Search")
        print("4. Quick Select Sort")
        print("5. Dual Pivot Quick Select Sort")
        print("6. Zamknij program")
        if let input1 = readLine(), let number1 = Int(input1) {
            switch number1 {
                case 1:
                    print()
                    print("Wybrałeś/aś Select'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        myArray = generateRandomKeys(number2)
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        print("Podaj statystykę pozycyjną")
                        if let input3 = readLine(), let positionStatistic = Int(input3) {
                            let posStat = positionStatistic
                            let kThElement = select(&myArray, 0, myArray.count-1, positionStatistic, &shiftCount, &compareCount)
                            if number2 < 50 {
                                print()
                                print("Wygenerowana tablica:")
                                printArray(arr)
                                print()
                                print("Końcowy stan tablicy:")
                                printArray(myArray)
                                print()
                                let arr = myArray.sorted()
                                print("Posortowana tablica:")
                                printArray(arr)
                                print()
                                print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                                print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                                print()
                                print("\(String(describing: posStat))-tą statystyką pozycyjną jest \(String(describing: kThElement))")
                                print("Elementem na \(String(describing: posStat))-tym miejscu w posortowanej tablicy jest \(String(describing: arr[posStat-1]))")
                            } else {
                                print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                                print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                                print("\(String(describing: posStat))-tą statystyką pozycyjną jest \(String(describing: kThElement))")
                                print("Elementem na \(String(describing: posStat))-tym miejscu w posortowanej tablicy jest \(String(describing: myArray[posStat]))")
                                print()
                            }
                        } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                        }  
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }

                case 2:
                    print("Wybrałeś/aś Randomized Select'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        myArray = generateRandomKeys(number2)
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        print("Podaj statystykę pozycyjną")
                        if let input3 = readLine(), let positionStatistic = Int(input3) {
                            let posStat = positionStatistic
                            let kThElement = randomizedSelect(&myArray, 0, myArray.count-1, positionStatistic, &shiftCount, &compareCount)
                            if number2 < 50 {
                                print()
                                print("Wygenerowana tablica:")
                                printArray(arr)
                                print()
                                print("Końcowy stan tablicy:")
                                printArray(myArray)
                                print()
                                let arr = myArray.sorted()
                                print("Posortowana tablica:")
                                printArray(arr)
                                print()
                                print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                                print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                                print()
                                print("\(String(describing: posStat))-tą statystyką pozycyjną jest \(String(describing: kThElement))")
                                print("Elementem na \(String(describing: posStat))-tym miejscu w posortowanej tablicy jest \(String(describing: arr[posStat-1]))")
                            } else {
                                print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                                print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                                print("\(String(describing: posStat))-tą statystyką pozycyjną jest \(String(describing: kThElement))")
                                print("Elementem na \(String(describing: posStat))-tym miejscu w posortowanej tablicy jest \(String(describing: myArray[posStat]))")
                                print()
                            }
                        } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                        }  
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }
                case 3:
                    print("Wybrałeś/aś Binary Search'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        myArray = generateRandomKeys(number2)
                        var arr = myArray.sorted()
                        var compareCount = 0
                        var shiftCount = 0
                        print("Podaj szukany element")
                        if let input3 = readLine(), let element = Int(input3) {
                            let kThElement = binarySearch(&arr, 0, arr.count-1, element, &shiftCount, &compareCount)
                            if number2 < 50 {
                                print()
                                print("Wygenerowana tablica:")
                                printArray(arr)
                                print()
                                print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                                print()
                                print("Element \(String(describing: element)) występuje w tablicy na \(String(describing: kThElement)) indeksie")
                            } else {
                                print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                                print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                                print("Element \(String(describing: kThElement)) występuje w tablicy na \(String(describing: kThElement)) indeksie")   
                                print()
                            }
                        } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                        }  
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }  

                case 4:
                    print("Wybrałeś/aś Quick Select Sort'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        myArray = generateRandomKeys(number2)
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        quickSelectSort(&myArray, 0, myArray.count-1, &shiftCount, &compareCount)
                        if number2 < 50 {
                            print()
                            print("Wygenerowana tablica:")
                            printArray(arr)
                            print()
                            print("Końcowy stan tablicy:")
                            printArray(myArray)
                            print()
                            print("Posortowana tablica:")
                            printArray(myArray.sorted())
                            print()
                            print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                            print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                            print()
                        } else {
                            print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                            print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                            print()
                        }  
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    }    
                case 5:
                    print("Wybrałeś/aś Dual Pivot Quick Select Sort'a!")
                    print("Podaj rozmiar tablicy do wygenerowania")
                    if let input2 = readLine(), let number2 = Int(input2) {
                        print("Wprowadzony rozmiar to: \(number2)")
                        print()
                        var myArray = [Int]()
                        myArray = generateRandomKeys(number2)
                        let arr = myArray
                        var compareCount = 0
                        var shiftCount = 0
                        dualPivotQuickSelectSort(&myArray, 0, myArray.count-1, &shiftCount, &compareCount)
                        if number2 < 50 {
                            print()
                            print("Wygenerowana tablica:")
                            printArray(arr)
                            print()
                            print("Końcowy stan tablicy:")
                            printArray(myArray)
                            print()
                            print("Posortowana tablica:")
                            printArray(myArray.sorted())
                            print()
                            print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                            print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                            print()
                        } else {
                            print("Liczba wykonanych porównań: \(String(describing:compareCount))")
                            print("Liczba wykonanych przestawień: \(String(describing:shiftCount))")
                            print()
                        }  
                    } else {
                        print("Nieprawidłowe dane wejściowe.")
                        print()
                    } 
                case 6:
                    exit(0)   
                
                default:
                    print("Nieprawidłowa wartość. Wybierz 1, 2 lub 3.")
                    print()
            }
        } else {
        print("Nieprawidłowe dane wejściowe.")
        print()
        }
    }
}

main()