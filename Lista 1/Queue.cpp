#include <stdexcept>
#include <iostream>

template<typename T>
struct Node {
    T data;
    Node* next;

    Node(T data) : data(data), next(nullptr) {}
};

template<typename T>
class Queue {
private:
    Node<T>* first;
    Node<T>* last;
    int size;

public:
    Queue() : first(nullptr), last(nullptr), size(0) {}

    void enqueue(T data) {
        Node<T>* newNode = new Node<T>(data);
        std::cout << "Dodano: " << data << std::endl;
        if (isEmpty()) {
            first = last = newNode;
        } else {
            last->next = newNode;
            last = newNode;
        }
        size++;
    }

    T dequeue() {
        if (isEmpty()) {
            throw std::out_of_range("Próba usunięcia z pustej kolejki!");
        }
        Node<T>* temp = first;
        T data = first->data;
        first = first->next;
        delete temp;
        size--;
        std::cout << "Usunięto: " << data << std::endl;
        return data;
    }

    bool isEmpty() const {
        return size == 0;
    }
};

int main() {
    Queue<int> queue;

    for (int i = 1; i <= 20; ++i) {
        queue.enqueue(i);
    }
    while (!queue.isEmpty()) {
        queue.dequeue();
    }

    return 0;
}
