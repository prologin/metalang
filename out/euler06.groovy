import java.util.*



int lim = 100
int sum = (int)((lim * (lim + 1)) / 2)
int carressum = sum * sum
int sumcarres = (int)((lim * (lim + 1) * (2 * lim + 1)) / 6)
print(carressum - sumcarres)

