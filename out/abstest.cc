#include <iostream>
#include <vector>

int abs_(int n) {
    if (n > 0)
        return n;
    else
        return -n;
}

int main() {
    std::cout << abs_(5 + 2) * 3 << 3 * abs_(5 + 2);
}

