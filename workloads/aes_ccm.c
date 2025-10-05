#include <stdio.h>
#include <string.h>

int main() {
    printf("[aes_ccm] Starting AES-CCM encryption workload...\n");
    volatile unsigned char data[1024];
    volatile unsigned char key[16] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
                                     0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10};
    
    for (int round = 0; round < 1000000; round++) {
        // Simulate AES-like operations
        for (int i = 0; i < 1024; i++) {
            data[i] = (data[i] ^ key[i % 16]) + (round & 0xFF);
        }
        if (round % 200000 == 0) {
            printf("[aes_ccm] progress: %d rounds\n", round);
        }
    }
    printf("[aes_ccm] Done! final byte=%d\n", data[0]);
    return 0;
}
