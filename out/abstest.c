#include <stdio.h>
#include <stdlib.h>


int abs_(int n) {
    if (n > 0)
        return n;
    else
        return -n;
}
int main(void) {
    printf("%d%d", abs_(5 + 2) * 3, 3 * abs_(5 + 2));
    return 0;
}


