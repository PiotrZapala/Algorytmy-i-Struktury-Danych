#include <iostream>
#include <stdexcept>
#include <vector>
#include <random>
#include <algorithm>

template<typename T>
struct Node {
    T data;
    Node* next;
    Node* prev;

    Node(T data) : data(data), next(nullptr), prev(nullptr) {}
};

template<typename T>
class DoubleLinkedList {
private:
    Node<T>* elem;
    int size;

public:
    DoubleLinkedList() : elem(nullptr), size(0) {}

    void enqueue(T data) {
        Node<T>* newNode = new Node<T>(data);
        std::cout << "Dodano: " << data << std::endl;
        if (isEmpty()) {
            elem = newNode;
            elem->next = elem;
            elem->prev = nullptr;
        } else {
            Node<T>* next = elem->next;
            Node<T>* prev = elem->prev;
            if (prev == nullptr) {
                elem->prev = newNode;
                elem->next = newNode;
                Node<T>* temp = elem;
                elem = newNode;
                elem->next = next;
                elem->prev = temp;
            } else {
                elem->next = newNode;
                elem = newNode;
                elem->next = next;
                elem->prev = prev;
            }
        }
        size++;
    }

    T dequeue() {
        if (isEmpty()) {
            throw std::out_of_range("Próba usunięcia z pustej listy!");
        }
        Node<T>* first = elem->next;
        T data = first->data;
        elem->next = first->next;
        first->next->prev = elem->next;
        delete first;
        size--;
        std::cout << "Usunięto: " << data << std::endl;
        return data;
    }

    static void insert(DoubleLinkedList<T>& list, T data) {
        Node<T>* newNode = new Node<T>(data);
        std::cout << "Dodano: " << data << std::endl;
        if (list.elem == nullptr) {
            list.elem = newNode;
            list.elem->next = list.elem;
            list.elem->prev = nullptr;
        } else {
            Node<T>* next = list.elem->next;
            Node<T>* prev = list.elem->prev;
            if (prev == nullptr) {
                list.elem->prev = newNode;
                list.elem->next = newNode;
                Node<T>* temp = list.elem;
                list.elem = newNode;
                list.elem->next = next;
                list.elem->prev = temp;
            } else {
                list.elem->next = newNode;
                list.elem = newNode;
                list.elem->next = next;
                list.elem->prev = prev;
            }
        }
        list.size++;
    }

    static DoubleLinkedList<T> merge(DoubleLinkedList<T>& list1, DoubleLinkedList<T>& list2) {
        DoubleLinkedList<T> mergedList;

        if (list1.isEmpty() && list2.isEmpty()) {
            return mergedList;
        }

        if (list1.isEmpty()) {
            return list2;
        }
        if (list2.isEmpty()) {
            return list1;
        }

        Node<T>* list1Last = list1.getElem();
        Node<T>* list2Last = list2.getElem();

        Node<T>* list1First = list1Last->next;
        Node<T>* list2First = list2Last->next;

        list1Last->next = list2First;
        list2Last->next = list1First;

        list1First->prev = list2Last;
        list2First->prev = list1Last;

        mergedList.elem = list2Last;
        mergedList.setSize(list1.getSize() + list2.getSize());

        return mergedList;
    }

    Node<T>* getElem() const {
        return elem;
    }

    int getSize() const {
        return size;
    }

    void setSize(int newSize) {
        size = newSize;
    }

    bool isEmpty() const {
        return size == 0;
    }
    
    int search(T target, bool isPresent) {
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> dist(0, 1);

        bool direction = dist(gen);
        Node<T>* current = (elem != nullptr) ? elem->next : nullptr;
        int comparisons = 0;

        if (current == nullptr) return comparisons;

        do {
            comparisons++;
            if (current->data == target) return comparisons;

            current = direction ? current->prev : current->next;
        } while (current != elem->next);

        if (!isPresent) {
            comparisons = size;
        }

        return comparisons;
    }
};

void test1() {
    DoubleLinkedList<int> doubleLinkedList1;

    for (int i = 1; i <= 20; ++i) {
        doubleLinkedList1.enqueue(i);
    }

    std::cout << " " << std::endl;

    doubleLinkedList1.insert(doubleLinkedList1, 21);
    doubleLinkedList1.insert(doubleLinkedList1, 22);
    doubleLinkedList1.insert(doubleLinkedList1, 23);
    doubleLinkedList1.insert(doubleLinkedList1, 24);
    doubleLinkedList1.insert(doubleLinkedList1, 25);

    std::cout << " " << std::endl;

    DoubleLinkedList<int> doubleLinkedList2;

    for (int i = 26; i <= 50; ++i) {
        doubleLinkedList2.enqueue(i);
    }

    std::cout << " " << std::endl;

    doubleLinkedList2.insert(doubleLinkedList2, 51);
    doubleLinkedList2.insert(doubleLinkedList2, 52);
    doubleLinkedList2.insert(doubleLinkedList2, 53);
    doubleLinkedList2.insert(doubleLinkedList2, 54);
    doubleLinkedList2.insert(doubleLinkedList2, 55);

    std::cout << " " << std::endl;

    DoubleLinkedList<int> newList = doubleLinkedList1.merge(doubleLinkedList1, doubleLinkedList2);

    while (!newList.isEmpty()) {
        newList.dequeue();
    }

}

void test2() {
    DoubleLinkedList<int> list;
    std::vector<int> numbers;
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, 100000);

    for (int i = 0; i < 10000; ++i) {
        int num = distrib(gen);
        list.insert(list, num);
        numbers.push_back(num);
    }

    int totalComparisonsFound = 0, totalComparisonsNotFound = 0;

    for (int i = 0; i < 1000; ++i) {
        int target = numbers[distrib(gen) % numbers.size()];
        totalComparisonsFound += list.search(target, true);
    }

    for (int i = 0; i < 1000; ++i) {
        int target = distrib(gen);
        totalComparisonsNotFound += list.search(target, false);
    }

    std::cout << "Średni koszt wyszukiwania liczby na liście: " << static_cast<double>(totalComparisonsFound) / 1000.0 << std::endl;
    std::cout << "Średni koszt wyszukiwania losowej liczby: " << static_cast<double>(totalComparisonsNotFound) / 1000.0 << std::endl;
}

int main() {
    test2();
    return 0;
}
