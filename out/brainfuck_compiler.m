#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>

/*
Ce test permet de tester les macros
C'est un compilateur brainfuck qui lit sur l'entrée standard pendant la compilation
et qui produit les macros metalang correspondante
*/
int main(void){
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  char input = ' ';
  int current_pos = 500;
  int a = 1000;
  int *mem = malloc( a * sizeof(int));
  {
    int i;
    for (i = 0 ; i < a; i++)
      mem[i] = 0;
  }
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  current_pos ++;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  mem[current_pos] = mem[current_pos] + 1;
  while (mem[current_pos] != 0)
  {
    mem[current_pos] = mem[current_pos] - 1;
    current_pos --;
    mem[current_pos] = mem[current_pos] + 1;
    printf("%c", mem[current_pos]);
    current_pos ++;
  }
  [pool drain];
  return 0;
}

