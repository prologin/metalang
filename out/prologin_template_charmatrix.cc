#include <iostream>
#include <vector>
std::vector<char> *getline(){
  if (std::cin.flags() & std::ios_base::skipws){
    char c = std::cin.peek();
    if (c == '\n' || c == ' ') std::cin.ignore();
    std::cin.unsetf(std::ios::skipws);
  }
  std::string line;
  std::getline(std::cin, line);
  std::vector<char> *c = new std::vector<char>(line.begin(), line.end());
  return c;
}
int programme_candidat(std::vector<std::vector<char> *> * tableau, int taille_x, int taille_y){
  int out0 = 0;
  for (int i = 0 ; i < taille_y; i++)
  {
    for (int j = 0 ; j < taille_x; j++)
    {
      out0 += (int)(tableau->at(i)->at(j)) * (i + j * 2);
      std::cout << tableau->at(i)->at(j);
    }
    std::cout << "--\n";
  }
  return out0;
}


int main(){
  int e, c;
  std::cin >> c >> std::skipws;
  int taille_x = c;
  std::cin >> e >> std::skipws;
  int taille_y = e;
  std::vector<std::vector<char> * > *g = new std::vector<std::vector<char> *>( taille_y );
  for (int h = 0 ; h < taille_y; h++)
    g->at(h) = getline();
  std::vector<std::vector<char> *> * tableau = g;
  std::cout << programme_candidat(tableau, taille_x, taille_y) << "\n";
  return 0;
}

