#include <iostream>
#include <exception>

template<typename T>
struct Node {
    T data;
    Node* next;

    Node(T data) : data(data), next(nullptr) {}
};

template<typename T>
class Stack {
private:
    Node<T>* top;
    int size;

public:
    Stack() : top(nullptr), size(0) {}

    void push(T data) {
        Node<T>* newNode = new Node<T>(data);
        std::cout << "Dodano: " << data << std::endl;
        if (top == nullptr) {
            top = newNode;
        } else {
            newNode->next = top;
            top = newNode;
        }
        size++;
    }

    T pop() {
        if (isEmpty()) {
            throw std::out_of_range("Próba usunięcia z pustego stosu!");
        }
        Node<T>* temp = top;
        T data = top->data;
        top = top->next;
        delete temp;
        size--;
        std::cout << "Usunięto " << data << std::endl;
        return data;
    }

    bool isEmpty() const {
        return size == 0;
    }
};

int main() {
    Stack<int> stack;

    for (int i = 1; i <= 50; ++i) {
        stack.push(i);
    }

    while (!stack.isEmpty()) {
        stack.pop();
    }

    return 0;
}
