#include <stdio.h>
#include <math.h>

int main() {
    printf("[tinyml_kws] Starting simulated inference workload...\n");
    volatile double sum = 0.0;
    for (int i = 0; i < 20000000; i++) {
        sum += sin(i * 0.001) * cos(i * 0.002);
        if (i % 5000000 == 0) {
            printf("[tinyml_kws] progress: %d iterations\n", i);
        }
    }
    printf("[tinyml_kws] Done! sum=%f\n", sum);
    return 0;
}

