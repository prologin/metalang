#include <iostream>
#include <vector>

int main() {
    int sum = 0;
    for (int i = 0; i <= 999; i += 1)
        if (i % 3 == 0 || i % 5 == 0)
            sum += i;
    std::cout << sum << "\n";
}
