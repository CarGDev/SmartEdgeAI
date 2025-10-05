#include <stdio.h>
#include <math.h>

int main() {
    printf("[sensor_fusion] Starting sensor fusion workload...\n");
    volatile double sum = 0.0;
    for (int i = 0; i < 15000000; i++) {
        sum += sqrt(i * 0.001) * log(i + 1);
        if (i % 3000000 == 0) {
            printf("[sensor_fusion] progress: %d iterations\n", i);
        }
    }
    printf("[sensor_fusion] Done! sum=%f\n", sum);
    return 0;
}
