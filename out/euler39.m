#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>
#include<math.h>


int main(void){
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int k, a, b, i;
  int *t = calloc(1001, sizeof(int));
  for (i = 0; i < 1001; i++)
      t[i] = 0;
  for (a = 1; a < 1001; a++)
      for (b = 1; b < 1001; b++)
      {
          int c2 = a * a + b * b;
          int c = (int)sqrt(c2);
          if (c * c == c2)
          {
              int p = a + b + c;
              if (p < 1001)
                  t[p]++;
          }
      }
  int j = 0;
  for (k = 1; k < 1001; k++)
      if (t[k] > t[j])
          j = k;
  printf("%d", j);
  [pool drain];
  return 0;
}


