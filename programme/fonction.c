#include "fonction.h"

// Fonction pour obtenir la valeur maximum (ou minimum si option_r != 0) entre deux nombres
double max(double a, double b, int option_r) {
    if (option_r!=0) {
        return (a > b)? b : a;
    }
    return (a > b)? a : b;
}

// Fonction pour obtenir la hauteur d'un noeud
int height(struct Node *N) {
    if (N == NULL)
        return 0;
    return N->height;
}

// Fonction pour créer un nouveau noeud
struct Node* newNode(double key) {
    struct Node* node = (struct Node*) malloc(sizeof(struct Node));
    node->key    = key;
    node->left   = NULL;
    node->right  = NULL;
    node->height = 1;
    return(node);
}

// Fonction pour effectuer une rotation à droite sur un noeud
struct Node* rightRotate(struct Node* y, int option_r) {
    struct Node *x = y->left;
    struct Node *T2 = x->right;

    // Effectuer une rotation
    x->right = y;
    y->left = T2;

    // Mettre à jour les hauteurs
    y->height = max(height(y->left), height(y->right), option_r)+1;
    x->height = max(height(x->left), height(x->right), option_r)+1;

    // Retourner le nouveau noeud racine
    return x;
}

// Fonction pour effectuer une rotation à gauche sur un noeud
struct Node* leftRotate(struct Node* x, int option_r) {
    struct Node *y = x->right;
    struct Node *T2 = y->left;

    // Effectuer une rotation
    y->left = x;
    x->right = T2;

    // Mettre à jour les hauteurs
    x->height = max(height(x->left), height(x->right), option_r)+1;
    y->height = max(height(y->left), height(y->right), option_r)+1;

    // Retourner le nouveau noeud racine
    return y;
}

int getBalance(struct Node *N) {
    if (N == NULL)
        return 0;
    return height(N->left) - height(N->right);
}

// Fonction pour insérer un nouveau noeud dans l'arbre
struct Node* insert(struct Node* node, double key, int option_r) {
    if (node == NULL)
        return(newNode(key));
    if (key < node->key)
        node->left  = insert(node->left, key, option_r);
    else if (key > node->key)
        node->right = insert(node->right, key, option_r);
    else
        return node;

    node->height = 1 + max(height(node->left), height(node->right), option_r);

    int balance = getBalance(node);

    if (balance > 1 && key < node->left->key)
        return rightRotate(node, option_r);

    if (balance < -1 && key > node->right->key)
        return leftRotate(node, option_r);

    if (balance > 1 && key > node->left->key) {
        node->left =  leftRotate(node->left, option_r);
        return rightRotate(node, option_r);
    }

    if (balance < -1 && key < node->right->key) {
        node->right = rightRotate(node->right, option_r);
        return leftRotate(node, option_r);
    }

    return node;
}

// Fonction pour parcourir l'arbre dans l'ordre croissant/décroissant selon la valeur de option_r
void inorder(struct Node *root, FILE *fp, int option_r) {
    if(root != NULL) {
	    if (option_r!=0) {
	        inorder(root->right, fp, option_r);
	        fprintf(fp, "%lf\n", root->key);
	        inorder(root->left, fp, option_r);
	    }
	    else {
	        inorder(root->left, fp, option_r);
	        fprintf(fp, "%lf\n", root->key);
	        inorder(root->right, fp, option_r);
	    }
    }
}

//Fonction de tri pour l'option --tab
void sort_tab(FILE *in, FILE *out, int option_r) {
    struct NodeTab *head = NULL;
    double num;
    while(fscanf(in, "%lf", &num) != EOF) {
        struct NodeTab *new_node = (struct NodeTab *)malloc(sizeof(struct NodeTab));
        new_node->data = num;
        new_node->next = NULL;

        if(head == NULL) //Liste vide
        {
            new_node->next = head;
            head = new_node;
        }
        else //Liste non vide
        {
            if (option_r==0) //Ordre croissant
            {
                if (head->data >= num)
                {
                    new_node->next = head;
                    head = new_node;
                }
                else
                {
                    struct NodeTab *curr = head;
                    while(curr->next != NULL && curr->next->data < num) {
                        curr = curr->next;
                    }
                    new_node->next = curr->next;
                    curr->next = new_node;
                }
            }
            else //Ordre décroissant
            {
                if (head->data <= num)
                {
                    new_node->next = head;
                    head = new_node;
                }
                else
                {
                    struct NodeTab *curr = head;
                    while(curr->next != NULL && curr->next->data > num) {
                        curr = curr->next;
                    }
                    new_node->next = curr->next;
                    curr->next = new_node;
                }
            }
        }
    }

    //Enregistrement dans le fichier de sortie
    struct NodeTab *curr = head;
    while(curr != NULL) {
        fprintf(out, "%lf\n", curr->data);
        curr = curr->next;
    }
}