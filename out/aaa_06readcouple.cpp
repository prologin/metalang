#include <iostream>
#include <vector>

int main() {
    int b, a;
    for (int i = 1; i < 4; i++)
    {
        std::cin >> a >> b;
        std::cout << "a = " << a << " b = " << b << "\n";
    }
    std::vector<int> l( 10 );
    for (int c = 0; c < 10; c++)
    {
        std::cin >> l[c];
    }
    for (int j = 0; j < 10; j++)
        std::cout << l[j] << "\n";
}

