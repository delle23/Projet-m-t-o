#!/bin/bash

t="vide"
p="vide"
tri="vide"
lieu="vide"
file="vide"

# 
while [ "$1" != "" ]; do
  case $1 in
    -t1)
      if [[ "$t" == "vide" ]]; then
        t=$1
        shift
      else
        echo "_$t_ Illegale combinaison de la temperature"
        exit
      fi
      ;;
    -t2)
      if [[ "$t" == "vide" ]]; then
        t=$1
        shift
      else
        echo "Illegale combinaison de la temperature"
        exit
      fi
      ;;
    -t3)
      if [[ "$t" == "vide" ]]; then
        t=$1
        shift
      else
        echo "Illegale combinaison de la temperature"
        exit
      fi
      ;;
    -p1)
      if [[ "$p" == "vide" ]]; then
        p=$1
        shift
      else
        echo "Illegale combinaison de la pression"
        exit
      fi
      ;;
    -p2)
      if [[ "$p" == "vide" ]]; then
        p=$1
        shift
      else
        echo "Illegale combinaison de la pression"
        exit
      fi
      ;;
    -p3)
      if [[ "$p" == "vide" ]]; then
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
      if [[ "$lieu" == "vide" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -G)
      if [[ "$lieu" == "vide" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -S)
      if [[ "$lieu" == "vide" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -A)
      if [[ "$lieu" == "vide" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -O)
      if [[ "$lieu" == "vide" ]]; then
        lieu=$1
      else
        echo "Illegale combinaison du lieu"
        exit
      fi
      shift
      ;;
    -Q)
      if [[ "$lieu" == "vide" ]]; then
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
    -f)
      shift
      file="$1"
      shift
      ;;
    --avl)
      if [[ "$tri" == "vide" ]]; then
        tri=$1
        shift
      else
        echo "Illegale combinaison du tri"
        exit
      fi
      ;;
    --abr)
      if [[ "$tri" == "vide" ]]; then
        tri=$1
        shift
      else
        echo "Illegale combinaison du tri"
        exit
      fi
      ;;
    --tab)
      if [[ "$tri" == "vide" ]]; then
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

if [[ "$file" == "vide" ]]; then
  echo "Option -f et fichier d'entree obligatoires"
  exit
fi

if [[ !(-f ./tmp.csv) ]]; then
  awk '{print $0;}' $file | sed '1d' > tmp.csv
fi
$file = "tmp.csv"

# Tests de récupération des arguments et options
#d1="$dmin"
d2="$dmax"
if [ d1!=0 ] 
then
  echo "d1 : $d1"
fi
echo "d2 : $d2"
echo "t : $t"
echo "p : $p"
echo "tri : $tri"
echo "lieu : $lieu"

# Filtrage des différents champs en fonction des arguments et options
if [[ "$h" == "ok" ]]; then
  awk -F";" '{ print $14 }' file > humidite_tmp.txt
fi
if [[ "$m" == "ok" ]]; then
  awk -F";" '{ print $6 }' file > humidite_tmp.txt
fi
if [[ "$t" == "-t1" ]]; then
  sort -k1,1 -t ';' "$file" | awk -F";" '{print $12$13$11}' > t1_tmp.txt
fi
# ///////


# Vérification de la présence du fichier exécutable progr
if [[ !(-f ./progr) ]]; then
  echo "Le fichier progr est absent. Lancement de la compilation..."
  make Makefile
else
  echo "Le fichier progr est present."
fi

# Exécution de tri en cas d'arguments necessitant le tri avec le programme en C
#if [[ "$tri" != "vide" ]]; then
  #statements
#fi
# ///////




# Exécution des commandes gnuPlot pour l'affichage des graphiques
# ///////