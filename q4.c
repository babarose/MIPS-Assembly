#include <stdio.h>
#include <stdbool.h>

#define MAX_ROWS 100
#define MAX_COLS 100

int matrix[MAX_ROWS][MAX_COLS];
int rows, cols;
int island_count, largest_island_count;

// Function prototypes
void dfs(int row, int col);
bool is_valid(int row, int col);

int main() {
    // Read matrix dimensions and elements
    scanf("%d, %d,", &rows, &cols);

    // Read matrix elements
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            scanf("%d,", &matrix[i][j]);
        }
    }

    // Initialize island counts
    island_count = 0;
    largest_island_count = 0;

    // Traverse each cell of the matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (matrix[i][j] == 1) {
                island_count++;
                dfs(i, j);
            }
        }
    }

    // Print the number of 1s in the largest island
    printf("The number of 1s on the largest island is %d.\n", largest_island_count);

    return 0;
}

// Depth-First Search (DFS) algorithm to explore the island
void dfs(int row, int col) {
    // Mark current cell as visited
    matrix[row][col] = 0;

    // Increment current island count
    largest_island_count++;

    // Define neighbors offsets (up, down, left, right)
    int dr[] = {-1, 1, 0, 0};
    int dc[] = {0, 0, -1, 1};

    // Explore neighboring cells
    for (int i = 0; i < 4; i++) {
        int new_row = row + dr[i];
        int new_col = col + dc[i];
        if (is_valid(new_row, new_col) && matrix[new_row][new_col] == 1) {
            dfs(new_row, new_col);
        }
    }
}

// Check if a cell is valid (within bounds)
bool is_valid(int row, int col) {
    return row >= 0 && row < rows && col >= 0 && col < cols;
}
