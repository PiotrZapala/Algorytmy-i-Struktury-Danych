#include <iostream>
#include <stdexcept>
#include <vector>
#include <random>
#include <algorithm>

template<typename T>
struct Node {
    T data;
    Node* next;

    Node(T data) : data(data), next(nullptr) {}
};

template<typename T>
class SingleLinkedList {
private:
    Node<T>* elem;
    int size;

public:
    SingleLinkedList() : elem(nullptr), size(0) {}

    void enqueue(T data) {
        Node<T>* newNode = new Node<T>(data);
        std::cout << "Dodano: " << data << std::endl;
        if (isEmpty()) {
            elem = newNode;
            elem->next = elem;
        } else {
            Node<T>* first = elem->next;
            elem->next = newNode;
            elem = newNode;
            elem->next = first;
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
        delete first;
        size--;
        std::cout << "Usunięto: " << data << std::endl;
        return data;
    }

    static void insert(SingleLinkedList<T>& list, T data) {
        Node<T>* newNode = new Node<T>(data);
        std::cout << "Dodano: " << data << std::endl;
        if (list.elem == nullptr) {
            list.elem = newNode;
            list.elem->next = newNode;
        } else {
            Node<T>* first = list.elem->next;
            list.elem->next = newNode;
            list.elem = newNode;
            list.elem->next = first;
        }
        list.size++;
    }

    static SingleLinkedList<T> merge(SingleLinkedList<T>& list1, SingleLinkedList<T>& list2) {
        SingleLinkedList<T> mergedList;

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
};

void test1() {
    SingleLinkedList<int> singleLinkedList1;

    for (int i = 1; i <= 20; ++i) {
        singleLinkedList1.enqueue(i);
    }

    std::cout << " " << std::endl;

    singleLinkedList1.insert(singleLinkedList1, 21);
    singleLinkedList1.insert(singleLinkedList1, 22);
    singleLinkedList1.insert(singleLinkedList1, 23);
    singleLinkedList1.insert(singleLinkedList1, 24);
    singleLinkedList1.insert(singleLinkedList1, 25);

    std::cout << " " << std::endl;

    SingleLinkedList<int> singleLinkedList2;

    for (int i = 26; i <= 50; ++i) {
        singleLinkedList2.enqueue(i);
    }

    std::cout << " " << std::endl;

    singleLinkedList2.insert(singleLinkedList2, 51);
    singleLinkedList2.insert(singleLinkedList2, 52);
    singleLinkedList2.insert(singleLinkedList2, 53);
    singleLinkedList2.insert(singleLinkedList2, 54);
    singleLinkedList2.insert(singleLinkedList2, 55);

    std::cout << " " << std::endl;

    SingleLinkedList<int> newList = singleLinkedList1.merge(singleLinkedList1, singleLinkedList2);

    while (!newList.isEmpty()) {
        newList.dequeue();
    }

}

void test2() {

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, 100000);

    SingleLinkedList<int> list;
    std::vector<int> numbers;

    for (int i = 0; i < 10000; ++i) {
        int num = distrib(gen);
        SingleLinkedList<int>::insert(list, num);
        numbers.push_back(num);
    }

    int totalComparisonsFound = 0;
    for (int i = 0; i < 1000; ++i) {
        int target = numbers[distrib(gen) % numbers.size()];
        Node<int>* current = list.getElem()->next;
        int comparisons = 0;
        do {
            comparisons++;
            if (current->data == target) {
                break;
            }
            current = current->next;
        } while (current != list.getElem()->next);
        totalComparisonsFound += comparisons;
    }
    std::cout << "Średni koszt wyszukiwania liczby na liście: " << (float)totalComparisonsFound / 1000.0f << std::endl;

    int totalComparisonsNotFound = 0;
    for (int i = 0; i < 1000; ++i) {
        int target = distrib(gen);
        Node<int>* current = list.getElem()->next;
        int comparisons = 0;
        do {
            comparisons++;
            if (current->data == target) {
                break;
            }
            current = current->next;
        } while (current != list.getElem()->next && comparisons <= list.getSize());
        totalComparisonsNotFound += (current->data == target) ? comparisons : list.getSize();
    }
    std::cout << "Średni koszt wyszukiwania losowej liczby: " << (float)totalComparisonsNotFound / 1000.0f << std::endl;
}

int main() {
    test2();
    return 0;
}
