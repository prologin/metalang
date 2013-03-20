#include<stdio.h>
#include<stdlib.h>

int count(void* a){ return ((int*)a)[-1]; }

int summax(int* lst, int len){
  int current = 0;
  int max_ = 0;
  {
    int i;
    for (i = 0 ; i <= len - 1; i++)
    {
      current = current + lst[i];
      if (current < 0)
      {
        current = 0;
      }
      if (max_ < current)
      {
        max_ = current;
      }
    }
  }
  return max_;
}

int main(void){
  int len = 0;
  scanf("%d", &len);
  scanf("%*[ \t\r\n]c", 0);
  int *tab = malloc( (len) * sizeof(int) + sizeof(int));
  ((int*)tab)[0]=len;
  tab=(int*)( ((int*)tab)+1);
  {
    int i;
    for (i = 0 ; i <= len - 1; i++)
    {
      int tmp = 0;
      scanf("%d", &tmp);
      scanf("%*[ \t\r\n]c", 0);
      tab[i] = tmp;
    }
  }
  int result = summax(tab, len);
  printf("%d", result);
  return 0;
}

