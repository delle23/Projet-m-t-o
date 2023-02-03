#!/bin/bash

t="vide"
p="vide"
tri="vide"
lieu="vide"

# 
while [ "$1" != "" ]; do
  case $1 in
    -t1)
      if [[ t!="vide" ]]; then
        t=$1
        shift
      else
        echo "Illegale combinaison de la temperature"
        exit
      fi
      ;;
    -t2)
      if [[ t!="vide" ]]; then
        t=$1
        shift
      else
        echo "Illegale combinaison de la temperature"
        exit
      fi
      ;;
    -t3)
      if [[ t!="vide" ]]; then
        t=$1
        shift
      else
        echo "Illegale combinaison de la temperature"
        exit
      fi
      ;;
    -p1)
      if [[ p=="" ]]; then
        p=$1
        shift
      else
        echo "Illegale combinaison de la pression"
        exit
      fi
      ;;
    -p2)
      if [[ p=="" ]]; then
        p=$1
        shift
      else
        echo "Illegale combinaison de la pression"
        exit
      fi
      ;;
    -p3)
      if [[ p=="" ]]; then
        p=$1
        shift
      else
        echo "Illegale combinaison de la pression"
        exit
      fi
      ;;
    -w)
      w="ok"
      shift
      ;;
    -h)
      h="ok"
      shift
      ;;
    -m)
      m="ok"
      shift
      ;;
    -F)
      if [[ lieu=="" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -G)
      if [[ lieu=="" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -S)
      if [[ lieu=="" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -A)
      if [[ lieu=="" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -O)
      if [[ lieu=="" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -Q)
      if [[ lieu=="" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -d)
      shift
      dmin="$1"
      shift
      dmax="$1"
      shift
      ;;
    --avl)
      if [[ tri=="" ]]; then
        tri=$1
        shift
      else
        echo "Illegale combinaison du tri"
        exit
      fi
      ;;
    --abr)
      if [[ tri=="" ]]; then
        tri=$1
        shift
      else
        echo "Illegale combinaison du tri"
        exit
      fi
      ;;
    --tab)
      if [[ tri=="" ]]; then
        tri=$1
        shift
      else
        echo "Illegale combinaison du tri"
        exit
      fi
      ;;
    *)
      echo "Usage: script.sh [-t<mode>] [-p<mode>] [-m] [-w] [-h] [-F | -G | -S | -A | -O | -Q] [d <min> <max>] [--avl | --abr | --tab]"
      exit
      ;;
  esac
done

# Tests de récupération des arguments et options
#d1="$dmin"
d2="$dmax"
if [[ d1!="" ]]; then
  echo "d1 : $d1"
fi
echo "d2 : $d2"
echo "t : $t"
echo "p : $p"
echo "tri : $tri"
echo "lieu : $lieu"

# Filtrage des différents champs en fonction des arguments et options
# ///////


# Vérification de la présence du fichier exécutable progr
if [[ !(-f ./progr) ]]; then
  echo "Le fichier progr est absent. Lancement de la compilation..."
  make Makefile
else
  echo "Le fichier progr est present."
fi

# Exécution de tri en cas d'arguments necessitant le tri avec le programme en C
# ///////




# Exécution des commandes gnuPlot pour l'affichage des graphiques
# ///////