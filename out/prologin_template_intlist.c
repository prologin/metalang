#include<stdio.h>
#include<stdlib.h>

int read_int(){
  int out_ = 0;
  scanf("%d ", &out_);
  return out_;
}

int* read_int_line(int n){
  int *tab = malloc( n * sizeof(int));
  {
    int i;
    for (i = 0 ; i < n; i++)
    {
      int t = 0;
      scanf("%d ", &t);
      tab[i] = t;
    }
  }
  return tab;
}

int programme_candidat(int* tableau, int taille){
  int out_ = 0;
  {
    int i;
    for (i = 0 ; i < taille; i++)
      out_ += tableau[i];
  }
  return out_;
}

int main(void){
  int taille = read_int();
  int* tableau = read_int_line(taille);
  printf("%d\n", programme_candidat(tableau, taille));
  return 0;
}

