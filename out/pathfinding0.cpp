#include <iostream>
#include <vector>
std::vector<char> getline(){
  if (std::cin.flags() & std::ios_base::skipws){
    char c = std::cin.peek();
    if (c == '\n' || c == ' ') std::cin.ignore();
    std::cin.unsetf(std::ios::skipws);
  }
  std::string line;
  std::getline(std::cin, line);
  std::vector<char> c(line.begin(), line.end());
  return c;
}
int min2_(int a, int b){
  if (a < b)
    return a;
  else
    return b;
}

int pathfind_aux(std::vector<std::vector<int > >& cache, std::vector<std::vector<char > >& tab, int x, int y, int posX, int posY){
  if (posX == x - 1 && posY == y - 1)
    return 0;
  else if (posX < 0 || posY < 0 || posX >= x || posY >= y)
    return x * y * 10;
  else if (tab[posY][posX] == '#')
    return x * y * 10;
  else if (cache[posY][posX] != -1)
    return cache[posY][posX];
  else
  {
    cache[posY][posX] = x * y * 10;
    int val1 = pathfind_aux(cache, tab, x, y, posX + 1, posY);
    int val2 = pathfind_aux(cache, tab, x, y, posX - 1, posY);
    int val3 = pathfind_aux(cache, tab, x, y, posX, posY - 1);
    int val4 = pathfind_aux(cache, tab, x, y, posX, posY + 1);
    int out0 = 1 + min2_(min2_(min2_(val1, val2), val3), val4);
    cache[posY][posX] = out0;
    return out0;
  }
}

int pathfind(std::vector<std::vector<char > >& tab, int x, int y){
  std::vector<std::vector<int > > cache(y);
  for (int i = 0 ; i < y; i++)
  {
    std::vector<int > tmp(x);
    for (int j = 0 ; j < x; j++)
    {
      std::cout << tab[i][j];
      tmp[j] = -1;
    }
    std::cout << "\n";
    cache[i] = tmp;
  }
  return pathfind_aux(cache, tab, x, y, 0, 0);
}


int main(){
  int y, x;
  std::cin >> x >> std::skipws >> y;
  std::cout << x << " " << y << "\n";
  std::vector<std::vector<char > > e(y);
  for (int f = 0 ; f < y; f++)
    e[f] = getline();
  std::vector<std::vector<char > > tab = e;
  int result = pathfind(tab, x, y);
  std::cout << result;
  return 0;
}
