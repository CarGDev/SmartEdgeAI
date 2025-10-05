#include <stdio.h>
#include <math.h>

int main() {
    printf("[attention_kernel] Starting attention mechanism workload...\n");
    volatile double attention[64][64];
    volatile double sum = 0.0;
    
    for (int iter = 0; iter < 500000; iter++) {
        // Simulate attention computation
        for (int i = 0; i < 64; i++) {
            for (int j = 0; j < 64; j++) {
                attention[i][j] = sin(i * 0.1) * cos(j * 0.1) + iter * 0.001;
                sum += attention[i][j];
            }
        }
        if (iter % 100000 == 0) {
            printf("[attention_kernel] progress: %d iterations\n", iter);
        }
    }
    printf("[attention_kernel] Done! sum=%f\n", sum);
    return 0;
}
