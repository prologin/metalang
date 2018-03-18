#include <iostream>
#include <vector>

int main() {
    std::vector<int> tab( 40 );
    for (int i = 0; i < 40; i++)
        tab[i] = i * i;
    std::cout << (tab).size() << "\n";
}

