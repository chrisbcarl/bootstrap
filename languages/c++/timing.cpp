#include <chrono>
#include <thread>
#include <iostream>

void func(int n) {
    std::this_thread::sleep_for(std::chrono::seconds(n));
}

int main(int argc, char** argv) {
    auto start = std::chrono::high_resolution_clock::now();
    func(100);
    auto stop = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start);
    std::cout << duration.count() << " ms" << std::endl;
}