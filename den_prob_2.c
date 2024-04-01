#include <stdio.h>
#include <stdlib.h>

// Function to find the greatest common divisor
int gcd(int a, int b) {
    if (b == 0)
        return a;
    return gcd(b, a % b);
}

// Function to find the least common multiple
int lcm(int a, int b) {
    return a * b / gcd(a, b);
}

// Function to check if two numbers are coprime
int areCoprime(int a, int b) {
    return gcd(a, b) == 1;
}

// Function to switch elements of an integer array based on coprimality
void switchElements(int arr[], int size) {
    int new_arr[size]; // Create a new array to store modified elements
    int new_size = 0; // Initialize size of new array

    for (int i = 0; i < size - 1; ++i) {
        if (areCoprime(arr[i], arr[i + 1])) {
            new_arr[new_size++] = arr[i]; // If coprime, add the element to new array
        } else {
            int new_element = lcm(arr[i], arr[i + 1]);
            new_arr[new_size++] = new_element; // Add least common multiple to new array
            ++i; // Skip the next element
        }
    }
    // Add the last element of original array to new array
    new_arr[new_size++] = arr[size - 1];

    // Check if the new array needs further processing
    int changed = 1;
    while (changed) {
        changed = 0;
        int j = 0;
        for (int i = 0; i < new_size - 1; ++i) {
            if (!areCoprime(new_arr[i], new_arr[i + 1])) {
                int new_element = lcm(new_arr[i], new_arr[i + 1]);
                new_arr[j++] = new_element;
                ++i; // Skip the next element
                changed = 1;
            } else {
                new_arr[j++] = new_arr[i];
            }
        }
        new_arr[j++] = new_arr[new_size - 1]; // Add the last element
        new_size = j;
    }

    printf("The new array is: ");
    for (int i = 0; i < new_size; ++i) {
        printf("%d ", new_arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {6, 4, 3, 2, 7, 13};
    int size = sizeof(arr) / sizeof(arr[0]);

    switchElements(arr, size);

    return 0;
}
