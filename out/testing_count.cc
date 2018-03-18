#include <iostream>
#include <vector>

int main() {
    std::vector<int> *tab = new std::vector<int>( 40 );
    for (int i = 0; i < 40; i++)
        tab->at(i) = i * i;
    std::cout << (tab)->size() << "\n";
}

