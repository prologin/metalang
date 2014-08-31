#include<stdio.h>
#include<stdlib.h>

int min2_(int a, int b){
  if (a < b)
    return a;
  else
    return b;
}

int eratostene(int* t, int max_){
  int i;
  int n = 0;
  for (i = 2 ; i < max_; i++)
    if (t[i] == i)
  {
    n ++;
    int j = i * i;
    if (j / i == i)
    {
      /* overflow test */
      while (j < max_ && j > 0)
      {
        t[j] = 0;
        j += i;
      }
    }
  }
  return n;
}

int main(void){
  int i, i_, k, o, j;
  int maximumprimes = 1000001;
  int *era = malloc( maximumprimes * sizeof(int));
  for (j = 0 ; j < maximumprimes; j++)
    era[j] = j;
  int nprimes = eratostene(era, maximumprimes);
  int *primes = malloc( nprimes * sizeof(int));
  for (o = 0 ; o < nprimes; o++)
    primes[o] = 0;
  int l = 0;
  for (k = 2 ; k < maximumprimes; k++)
    if (era[k] == k)
  {
    primes[l] = k;
    l ++;
  }
  printf("%d == %d\n", l, nprimes);
  int *sum = malloc( nprimes * sizeof(int));
  for (i_ = 0 ; i_ < nprimes; i_++)
    sum[i_] = primes[i_];
  int maxl = 0;
  int process = 1;
  int stop = maximumprimes - 1;
  int len = 1;
  int resp = 1;
  while (process)
  {
    process = 0;
    for (i = 0 ; i <= stop; i++)
      if (i + len < nprimes)
    {
      sum[i] = sum[i] + primes[i + len];
      if (maximumprimes > sum[i])
      {
        process = 1;
        if (era[sum[i]] == sum[i])
        {
          maxl = len;
          resp = sum[i];
        }
      }
      else
      {
        int c = min2_(stop, i);
        stop = c;
      }
    }
    len ++;
  }
  printf("%d\n%d\n", resp, maxl);
  return 0;
}


