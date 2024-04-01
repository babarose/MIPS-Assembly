#include <stdio.h>

// Function prototype
int SequenceCalculation(int a, int b, int x0, int x1, int n);

int main(void) {
    int a, b, x0, x1, n, result;

    // Prompt the user to enter coefficients (a and b)
    printf("Please enter the coefficients: ");
    scanf("%d %d", &a, &b);
    
    // Prompt the user to enter the first two numbers of the sequence (x0 and x1)
    printf("Please enter first two numbers of the sequence: ");
    scanf("%d %d", &x0, &x1);
    
    // Prompt the user to enter the value of n
    printf("Enter the number you want to calculate (it must be greater than 1): ");
    scanf("%d", &n);

    // Check if n is less than or equal to 1, if so, prompt the user to enter a valid value
    if (n <= 1) {
        printf("Error! The number should be greater than 1.\n");
        return 1;
    }

    // Calculate the nth element of the sequence
    result = SequenceCalculation(a, b, x0, x1, n);
    
    // Print the result
    printf("Output: %dth element of the sequence is %d.\n", n, result);

    return 0;
}

// Function to calculate the nth element of the sequence
int SequenceCalculation(int a, int b, int x0, int x1, int n) {
    int result = 0;
    int i;
    int f0 = x0;
    int f1 = x1;

    // If n is 0 or 1, return the corresponding initial values
    if (n == 0) {
        return f0;
    }

    if (n == 1) {
        return f1;
    }

    // Iterate through the sequence to calculate the nth element
    for (i = 3; i <= n; ++i) {
        // Calculate the next element using the provided equation
        result = a * f1 + b * f0 - 2;
        // Update f0 and f1 for the next iteration
        f0 = f1;
        f1 = result;
    }
    
    // Return the nth element of the sequence
    return result;
}
