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
int programme_candidat(std::vector<std::vector<char > >& tableau, int taille_x, int taille_y){
  int out0 = 0;
  for (int i = 0 ; i < taille_y; i++)
  {
    for (int j = 0 ; j < taille_x; j++)
    {
      out0 += (int)(tableau[i][j]) * (i + j * 2);
      std::cout << tableau[i][j];
    }
    std::cout << "--\n";
  }
  return out0;
}


int main(){
  int taille_y, taille_x;
  std::cin >> taille_x >> std::skipws >> taille_y;
  std::vector<std::vector<char > > a(taille_y);
  for (int b = 0 ; b < taille_y; b++)
    a[b] = getline();
  std::vector<std::vector<char > > tableau = a;
  std::cout << programme_candidat(tableau, taille_x, taille_y) << "\n";
  return 0;
}
