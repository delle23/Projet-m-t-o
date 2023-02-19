#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fonction.h"

int option_r = 0;

int main(int argc, char *argv[]) {
  char *input_file = NULL;
  char *output_file = NULL;
  char *tree_type = NULL;
  FILE* input=NULL;
  FILE* output=NULL;

  //On parcours les arguments pour vérifier ceux qui sont présents en faisant des comparaisons avec strcmp(..,..)
  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-f") == 0) {
      input_file = argv[i+1];
      i++;
    } else if (strcmp(argv[i], "-o") == 0) {
      output_file = argv[i+1];
      i++;
    } else if (strcmp(argv[i], "-r") == 0) {
      option_r = 1;
    } else if (strcmp(argv[i], "--tab") == 0) {
      //Si une méthode de tri avait déjà été précisée, on retourne 1
      if (tree_type!=NULL)
        return 1;
      tree_type = "tab";
    } else if (strcmp(argv[i], "--abr") == 0) {
      //Si une méthode de tri avait déjà été précisée, on retourne 1
      if (tree_type!=NULL)
        return 1;
      tree_type = "abr";
    } else if (strcmp(argv[i], "--avl") == 0) {
      //Si une méthode de tri avait déjà été précisée, on retourne 1
      if (tree_type!=NULL)
        return 1;
      tree_type = "avl";
    } else {
      //Option non reconnue, on retourne 1
      return 1;
    }
  }

  //Vérification des cas d'erreurs
  //Vérification de la réception des arguments obligatoires
  if (input_file==NULL && output_file==NULL) 
  {
  	//Option de fichiers manquant
  	/**/printf("Fichier input ou output manquant\n");
  	return 1;
  }

  //Ouverture des fichiers d'entrées et sorties
  input = fopen(input_file,"r");
  if (input==NULL)
  {
  	//Erreur lors de l'ouverture du fichier d'entrées, on retourne 2
  	return 2;
  }
  output = fopen(output_file,"w+");
  if (output==NULL)
  {
  	//Erreur lors de l'ouverture du fichier de sortie, on retourne 3
  	return 3;
  }

  /*printf("Fichier d'entrée : %s\n", input_file);*/
  /*printf("Fichier de sortie : %s\n", output_file);*/
  /*printf("Option -r : %d\n", option_r);*/
  /*printf("Type d'arbre : %s\n", tree_type);*/

  //Tri des données en foction de la méthode de tri
  if (strcmp(tree_type,"avl")==0 || tree_type==NULL)
  {
    //Tri par algorithme AVL
    struct Node *rootAVL = NULL;
    double n;
    while (fscanf(input, "%lf", &n) != EOF)
    {
      rootAVL = insert(rootAVL, n, option_r);
    }
    inorder(rootAVL, output, option_r);
  }
  else if (strcmp(tree_type,"abr")==0)
  {
    //Tri par algorithme ABR
    struct Node *root = NULL;
    double n;
    while (fscanf(input, "%lf", &n) != EOF)
    {
      root = insert(root, n, option_r);
    }
    inorder(root, output, option_r);
  }
  else if (strcmp(tree_type,"tab")==0)
  {
    //Tri par simple algorithme de liste chainée
    sort_tab(input, output, option_r);
  }

  //Libération des mémoires allouées aux pointeurs de fichiers
  fclose(input);
  fclose(output);
  return 0;
}
