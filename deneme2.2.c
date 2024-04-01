#include <stdio.h>
#include <stdlib.h>

int gcd(int num1, int num2) {
    int temp;
    while (num2 != 0) {
        temp = num2;
        num2 = num1 % num2;
        num1 = temp;
    }
    return num1;
}

void switch_elements(int *array, int *length) {
    int is_changed = 1; // Flag to check if any changes were made in the array
    while (is_changed) {
        is_changed = 0; // Reset the flag at the beginning of each iteration
        for (int i = 0; i < *length - 1; i++) {
            if (gcd(array[i], array[i + 1]) != 1) {
                int lcf = array[i] * array[i + 1] / gcd(array[i], array[i + 1]);
                array[i] = lcf; // Replace the first element with the least common factor

                // Shift elements to the left, starting from the next element
                for (int j = i + 1; j < *length - 1; j++) {
                    array[j] = array[j + 1];
                }
                (*length)--; // Decrease the length of the array
                i--; // Decrement i to recheck the current position in the next iteration
                is_changed = 1; // Set the flag to indicate a change in the array
            }
        }
    }
}

int main() {
    int *array = NULL; // Declare pointer to int and initialize it to NULL
    int length = 0;
    printf("Enter the elements of the array separated by spaces: ");
    char c;
    // Dynamically allocate memory for the array
    array = malloc(sizeof(int));

    while (scanf("%d%c", &array[length], &c) == 2 && c != '\n') {
        length++;
        array = realloc(array, (length + 1) * sizeof(int)); // Dynamically resize the array
    }
    length++;

    switch_elements(array, &length);

    printf("The new array is: ");
    for (int i = 0; i < length; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");

    // Free dynamically allocated memory
    free(array);

    return 0;
}