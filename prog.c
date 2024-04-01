#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define Max 1024

void swapSubstrings(char* substring, int length, int n);

int main() {
    char InputString[Max];
    int ShuffleTimes;

    // Take input string from the user
    printf("Input: ");
    fgets(InputString, sizeof(InputString), stdin);

    // Remove newline character
    InputString[strcspn(InputString, "\n")] = '\0'; 

    // Take the number of shuffle operations from the user
    scanf("%d", &ShuffleTimes);

    // Calculate length of the string
    int length = strlen(InputString);

    // Perform shuffle operation
    swapSubstrings(InputString, length, ShuffleTimes);

    // Print shuffled string
    printf("Output: \"%s\"\n", InputString);

    return 0;
}

// Function to recursively swap substrings in a string
void swapSubstrings(char* substring, int length, int n) {
    if (n <= 0) return;

    int mid = length / 2;
    char temp[mid];
    strncpy(temp, substring, mid);
    // Null-terminate the temporary string
    temp[mid] = '\0';

    // Swap first half with second half
    for (int i = 0; i < mid; i++) {
        char temp = substring[i];
        substring[i] = substring[mid + i];
        substring[mid + i] = temp;
    }

    // memmove(substring, substring + mid, mid);
    // memcpy(substring + mid, temp, mid);

    // Recursively swap sub-substrings
    // printf("Internal: \"%s\"\n", substring);
    swapSubstrings(substring, mid, n - 1);
    // printf("Internal: \"%s\"\n", substring);
    swapSubstrings(substring + mid, mid, n - 1);
    // printf("Internal: \"%s\"\n", substring);
}
