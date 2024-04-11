#include "state.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_state_t *state, unsigned int row, unsigned int col, char ch);

static bool is_tail(char c);

static bool is_head(char c);

static bool is_snake(char c);

static char body_to_tail(char c);

static char head_to_body(char c);

static unsigned int get_next_row(unsigned int cur_row, char c);

static unsigned int get_next_col(unsigned int cur_col, char c);

static void find_head(game_state_t *state, unsigned int snum);

static char next_square(game_state_t *state, unsigned int snum);

static void update_tail(game_state_t *state, unsigned int snum);

static void update_head(game_state_t *state, unsigned int snum);

/* Task 1 */
game_state_t *create_default_state() {
    // The board has 18 rows, and each row has 20 columns.
    const unsigned int DEFAULT_NUM_ROWS = 18;

    game_state_t *state = malloc(sizeof(game_state_t));
    state->num_rows = DEFAULT_NUM_ROWS;
    state->board = malloc(state->num_rows * sizeof(char *));
    // Each row is a string, should add '\0' in end.
    const unsigned int cols = 21;
    for (int i = 0; i < state->num_rows; i++) {
        state->board[i] = malloc(cols * sizeof(char));
    }

    const unsigned int tail_row = 2, tail_col = 2;
    const unsigned int head_row = 2, head_col = 4;
    const unsigned int fruit_row = 2, fruit_col = 9;
    // The fruit is at row 2, column 9 (zero-indexed).
    // The tail is at row 2, column 2, and the head is at row 2, column 4.
    for (int i = 0; i < state->num_rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (j == cols - 1) {
                state->board[i][j] = '\0';
            } else if (i == 0 || i == state->num_rows - 1 || j == 0 || j == cols - 2) {
                state->board[i][j] = '#';
            } else if (i == tail_row && j == tail_col) {
                state->board[i][j] = 'd';
            } else if (i == tail_row && j == tail_col + 1) {
                state->board[i][j] = '>';
            } else if (i == head_row && j == head_col) {
                state->board[i][j] = 'D';
            } else if (i == fruit_row && j == fruit_col) {
                state->board[i][j] = '*';
            } else {
                state->board[i][j] = ' ';
            }
        }
    }

    state->num_snakes = 1;
    state->snakes = malloc(sizeof(snake_t));
    state->snakes[0].head_row = head_row;
    state->snakes[0].head_col = head_col;
    state->snakes[0].tail_row = tail_row;
    state->snakes[0].tail_col = tail_col;
    state->snakes[0].live = true;

    return state;
}

/* Task 2 */
void free_state(game_state_t *state) {
    free(state->snakes);
    for (int i = 0; i < state->num_rows; i++) {
        free(state->board[i]);
    }
    free(state->board);
    free(state);
}

/* Task 3 */
void print_board(game_state_t *state, FILE *fp) {
    for (int i = 0; i < state->num_rows; i++) {
        fprintf(fp, "%s\n", state->board[i]);
    }
}

/*
  Saves the current state into filename. Does not modify the state object.
  (already implemented for you).
*/
void save_board(game_state_t *state, char *filename) {
    FILE *f = fopen(filename, "w");
    print_board(state, f);
    fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_state_t *state, unsigned int row, unsigned int col) {
    return state->board[row][col];
}

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_state_t *state, unsigned int row, unsigned int col, char ch) {
    state->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
    return c == 'w' || c == 'a' || c == 's' || c == 'd';
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
    return c == 'W' || c == 'A' || c == 'S' || c == 'D' || c == 'x';
}

/*
  Returns true if c is part of the snake's body.
  The snake consists of these characters: "^<v>"
  Returns false otherwise.
*/
static bool is_body(char c) {
    return c == '^' || c == '<' || c == 'v' || c == '>';
}


/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
    return is_head(c) || is_tail(c) || is_body(c);
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
    if (c == '^') {
        return 'w';
    } else if (c == '<') {
        return 'a';
    } else if (c == 'v') {
        return 's';
    } else if (c == '>') {
        return 'd';
    } else {
        return '\0';
    }
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
    if (c == 'W') {
        return '^';
    } else if (c == 'A') {
        return '<';
    } else if (c == 'S') {
        return 'v';
    } else if (c == 'D') {
        return '>';
    } else {
        return '\0';
    }
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
    if (c == 'v' || c == 's' || c == 'S') {
        return cur_row + 1;
    } else if (c == '^' || c == 'w' || c == 'W') {
        return cur_row - 1;
    } else {
        return cur_row;
    }
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
    if (c == '>' || c == 'd' || c == 'D') {
        return cur_col + 1;
    } else if (c == '<' || c == 'a' || c == 'A') {
        return cur_col - 1;
    } else {
        return cur_col;
    }
}

/*
  Task 4.2

  Helper function for update_state. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_state_t *state, unsigned int snum) {
    // get current character of snake head.
    snake_t *snake = &(state->snakes[snum]);
    char c = get_board_at(state, snake->head_row, snake->head_col);
    unsigned int next_row = get_next_row(snake->head_row, c);
    unsigned int next_col = get_next_col(snake->head_col, c);
    return get_board_at(state, next_row, next_col);
}

/*
  Task 4.3

  Helper function for update_state. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_state_t *state, unsigned int snum) {
    snake_t *snake = &(state->snakes[snum]);
    char c = get_board_at(state, snake->head_row, snake->head_col);
    unsigned int next_row = get_next_row(snake->head_row, c);
    unsigned int next_col = get_next_col(snake->head_col, c);
    state->board[snake->head_row][snake->head_col] = head_to_body(c);
    state->board[next_row][next_col] = c;
    snake->head_row = next_row;
    snake->head_col = next_col;
}

/*
  Task 4.4

  Helper function for update_state. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_state_t *state, unsigned int snum) {
    snake_t *snake = &(state->snakes[snum]);
    char c = get_board_at(state, snake->tail_row, snake->tail_col);
    unsigned int next_row = get_next_row(snake->tail_row, c);
    unsigned int next_col = get_next_col(snake->tail_col, c);
    char x = get_board_at(state, next_row, next_col);
    state->board[next_row][next_col] = body_to_tail(x);
    state->board[snake->tail_row][snake->tail_col] = ' ';
    snake->tail_row = next_row;
    snake->tail_col = next_col;
}

/* Task 4.5 */
void update_state(game_state_t *state, int (*add_food)(game_state_t *state)) {
    for (unsigned int i = 0; i < state->num_snakes; i++) {
        char x = next_square(state, i);
        // If the head crashes into the body of a snake or a wall,
        // the snake dies and stops moving. When a snake dies, the head is replaced with an x.
        if (x == '#' || is_snake(x)) {
            state->board[state->snakes[i].head_row][state->snakes[i].head_col] = 'x';
            state->snakes[i].live = false;
        } else if (x == '*') {
            update_head(state, i);
            add_food(state);
        } else {
            update_head(state, i);
            update_tail(state, i);
        }
    }
}

/* Task 5 */
game_state_t *load_board(FILE *fp) {
    // TODO: Implement this function.
    return NULL;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_state_t *state, unsigned int snum) {
    // TODO: Implement this function.
    return;
}

/* Task 6.2 */
game_state_t *initialize_snakes(game_state_t *state) {
    // TODO: Implement this function.
    return NULL;
}
