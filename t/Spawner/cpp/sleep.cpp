#include <thread>
#include <chrono>
#include <iostream>


int main() {
    std::this_thread::sleep_for(std::chrono::milliseconds(2000));
    std::cout << "aaa";
}