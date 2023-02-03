#include <stdio.h>
#include <stdlib.h>

struct Node {
    double key;
    struct Node *left;
    struct Node *right;
    int height;
};

struct NodeTab {
    double data;
    struct NodeTab *next;
};

double max(double a, double b, int option_r);
int height(struct Node *N);
struct Node* newNode(double key);
struct Node* rightRotate(struct Node* y, int option_r);
struct Node* leftRotate(struct Node* x, int option_r);
int getBalance(struct Node *N);
struct Node* insert(struct Node* node, double key, int option_r);
void inorder(struct Node *root, FILE *fp, int option_r);
void sort_tab(FILE *in, FILE *out, int option_r);