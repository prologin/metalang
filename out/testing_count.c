#include <stdio.h>
#include <stdlib.h>
int count(void* a){ return ((int*)a)[-1]; }

void* alloc(int a, int size){
  void *out_ = malloc( a * size + sizeof(int));
  ((int*)out_)[0]=a;
  return ((int*)out_)+1;
}


int main(void) {
    int i;
    int *tab = alloc(40, sizeof(int));
    for (i = 0; i < 40; i++)
        tab[i] = i * i;
    printf("%d\n", count(tab));
    return 0;
}


