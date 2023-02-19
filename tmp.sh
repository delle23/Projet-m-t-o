#!/bin/bash

args=$*
t="vide"
p="vide"
h="vide"
m="vide"
w="vide"
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
    --help)
      echo "Aide :"
      echo "Usage: script.sh [-t<mode>] [-p<mode>] [-m] [-w] [-h] [-F | -G | -S | -A | -O | -Q] [d <min> <max>] [--avl | --abr | --tab]"
      exit
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

$0 = "$args"

#Vérification des arguments obligatoires
if [ "$t" == "vide" -a "$p" == "vide" -a "$h" == "vide" -a "$m" == "vide" -a "$w" == "vide" ]; then
  echo "Au moins l’une de des options -w -h -m -p -t doit être choisie"
  exit
fi

#Configuration du fichier d'entrées
if [[ "$file" == "vide" ]]; then
  echo "Option -f et fichier d'entrees obligatoires"
  exit
else
  cat $file | sed '1d' | tr ',' '_' | tr '.' ',' > __tmp
fi
#file = "__tmp"

# Tests de récupération des arguments et options
#d1="$dmin"
#d2="$dmax"
#if [ d1!=0 ] 
#then
#  echo "d1 : $d1"
#fi
#echo "d2 : $d2"
#echo "t : $t"
#echo "p : $p"
#echo "tri : $tri"
#echo "lieu : $lieu"

# Filtrage des différents champs en fonction des arguments et options

# Filtrage par date
if [[ "$args" == *"-d"* ]]; then
  interval=$(echo $args | grep -o "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}")
  dmin=$(echo $interval | awk '{ print $1}')
  dmax=$(echo $interval | awk '{ print $2}')
  if [[ "$dmin" == "" && "$dmax" == "" ]]; then
    echo "Erreur !! Veuillez bien definir l'intervalle apres l'argument -d"
    exit
  fi
  awk -F";" -v dmin="$dmin" -v dmax="$dmax" '{if(dmin<=substr($2, 0, 10) && substr($2, 0, 10)<=dmax) print $0;}' __tmp >__tmp_2
  mv __tmp_2 __tmp
  # echo "$dmin et $dmax"
fi

# FILTRAGE GEOGRAPHIQUE
declare -A long
declare -A lat
lat["F"]="41,0_51,0"
lat["G"]="1,0_6,0"
lat["S"]="46,5_47,0"
lat["A"]="10,0_20,0"
lat["O"]="-40,0_40,0"
lat["Q"]="-90,0_-60,0"

long["F"]="-6,0_9,0"
long["G"]="-58,0_-51,0"
long["S"]="-56,0_-55,0"
long["A"]="-80,0_-60,0"
long["O"]="40,0_120,0"
long["Q"]="-180,0_180,0"

filtrage_georaphique() {
  result=$(echo ${lat[$1]} | grep -Eo '[-]?[0-9]+[,][0-9]+_[-]?[0-9]+[,][0-9]+')
  IFS='_' read -r latMin latMax <<<"$result"
  result=$(echo ${long[$1]} | grep -Eo '[-]?[0-9]+[,][0-9]+_[-]?[0-9]+[,][0-9]+')
  IFS='_' read -r longMin longMax <<<"$result"
  awk -F";" -v latMin="$latMin" -v latMax="$latMax" -v longMin="$longMin" -v longMax="$longMax" '
{
  split($10, coor, "_")
  if (coor[1]+0 >= latMin+0 && coor[1]+0 <= latMax+0 && coor[2]+0 >= longMin+0 && coor[2]+0 <= longMax+0) print
}' __tmp >__tmp_2
  mv __tmp_2 __tmp
}

if [[ $* == *"-F"* ]]; then
  filtrage_georaphique "F"
fi

if [[ $* == *"-G"* ]]; then
  filtrage_georaphique "G"
fi

if [[ $* == *"-S"* ]]; then
  filtrage_georaphique "S"
fi

if [[ $* == *"-A"* ]]; then
  filtrage_georaphique "A"
fi

if [[ $* == *"-O"* ]]; then
  filtrage_georaphique "O"
fi

if [[ $* == *"-Q"* ]]; then
  filtrage_georaphique "Q"
fi
# cat __tmp | head -n 100

# Les options de sortie
if [[ "$w" == "ok" ]]; then #4 et 5 vent ok
  echo "Extraction des donnees de vent"
  awk -F";" '{ print $4";"$5}' __tmp > vent.txt
fi

if [[ "$h" == "ok" ]]; then #14 altitute ok
  echo "Extraction des donnees d'altitude"
  awk -F";" '{ print $14 }' __tmp > altitude.txt
fi

if [[ "$m" == "ok" ]]; then #6 humidite ok
  echo "Extraction des donnees d'humidite"
  awk -F";" '{ print $6 }' __tmp > humidite.txt
fi

if [[ "$t" == "-t1" ]]; then # $11 minimal , maximal et moyenne par station
  echo "Extraction des donnees de temperature mode 1"
  awk -F";" '{if ($11!="") print $0 }' __tmp | awk -F";" '
{
  if(min[$1] == "" || min[$1] > $11) min[$1] = $11
  max[$1]=max[$1]>$11?max[$1]:$11
  sum[$1]=sum[$1]+$11
  count[$1]++
}
END{
for (i in min) {
printf("%s;%f;%f;%f\n", i, min[i], max[i], sum[i]/count[i])
   }
} ' | sort -t";" -k1,1 > temperature1.txt
fi

if [[ "$t" == "-t2" ]]; then #11 les températures moyenne par date/heure triee par date/heure
  echo "Extraction des donnees de temperature mode 2"
  awk -F";" '$11!="" {print}' __tmp >__tmp_2
  awk -F";" '{s[$2]+=$11; c[$2]++} END {
    for (i in s) printf "%s;%.6f\n", i, s[i]/c[i]
  }' __tmp_2 | sort -t";" -k1,1 > temperature2.txt
  rm __tmp_2
fi

if [[ "$t" == "-t3" ]]; then
  echo "Extraction des donnees de temperature mode 3"
  sort -t ";" -k2,2 -k1,1 __tmp | awk -F";" '{print $2";"$1";"$11 }' > temperature3.txt
fi

if [[ "$p" == "-p1" ]]; then # $7 minimal , maximal et moyenne par station
  echo "Extraction des donnees de pression mode 1"
  awk -F";" '{if ($7!="") print $0 }' __tmp | awk -F";" '
{
  if(min[$1] == "" || min[$1] > $7) min[$1] = $7
  max[$1]=max[$1]>$7?max[$1]:$7
  sum[$1]=sum[$1]+$7
  count[$1]++
}
END{
for (i in min) {
printf("%s;%.2f;%.2f;%f\n", i, min[i], max[i], sum[i]/count[i])
   }
} ' | sort -t";" -k1,1 > pression1.txt
fi

if [[ "$p" == "-p2" ]]; then #$7 les pressions moyenne par date/heure triee par date/heure
  echo "Extraction des donnees de pression mode 2"
  awk -F";" '$7!="" {print}' __tmp >__tmp_2
  awk -F";" '{s[$2]+=$7; c[$2]++} END {
    for (i in s) printf "%s;%.6f\n", i, s[i]/c[i]
  }' __tmp_2 | sort -t";" -k1,1 > pression2.txt
  rm __tmp_2
fi

if [[ "$p" == "-p3" ]]; then
  echo "Extraction des donnees de pression mode 3"
  sort -t ";" -k2,2 -k1,1 __tmp | awk -F";" '{print $2";"$1";"$7 }' > pression3.txt
fi

#if [[ "$h" == "ok" ]]; then
#  awk -F";" '{ print $14 }' file > humidite_tmp.txt
#fi
#if [[ "$m" == "ok" ]]; then
#  awk -F";" '{ print $6 }' file > humidite_tmp.txt
#fi
#if [[ "$w" == "ok" ]]; then
#  sort -k1,1 -t ';' "$file" | awk -F";" '{print $12$13$11}' > t1_tmp.txt
#fi
# ///////


# Vérification de la présence du fichier exécutable progr
if [[ !(-f ./progr) ]]; then
  echo "Le fichier progr est absent. Lancement de la compilation..."
  make -f Makefile
else
  echo "Le fichier progr est present. On passe la compilation."
fi

# Exécution de tri en cas d'arguments necessitant le tri avec le programme en C
declare result_tri
result_tri="vide"
if [[ "$tri" != "vide" ]]; then
  # //
  if [[ "$tri" == "--abr" ]]; then
    if [[ "$h" == "ok" ]]; then
      echo "Tri des donnees d'altitude par ABR"
      result_tri=$(./progr -f altitude.txt -o h.txt -r --abr)
      if [[ "$result_tri" == "1" ]]; then
        echo "progr retourne $result_tri : Erreur sur options activees"
      elif [[ "$result_tri" == "2" ]]; then
        echo "progr retourne $result_tri : Erreur avec le fichier de donnees d'entree"
      elif [[ "$result_tri" == "3" ]]; then
        echo "progr retourne $result_tri : Erreur avec le fichier de donnees de sortie"
      elif [[ "$result_tri" == "4" ]]; then
        echo "progr retourne $result_tri : Erreur inattendue..."
      fi
    fi
    if [[ "$m" == "ok" ]]; then
      echo "Tri des donnees d'humidite par ABR"
      result_tri=$(./progr -f humidite.txt -o m.txt -r --abr)
      if [[ "$result_tri" == "1" ]]; then
        echo "progr retourne $result_tri : Erreur sur options activees"
      elif [[ "$result_tri" == "2" ]]; then
        echo "progr retourne $result_tri : Erreur avec le fichier de donnees d'entree"
      elif [[ "$result_tri" == "3" ]]; then
        echo "progr retourne $result_tri : Erreur avec le fichier de donnees de sortie"
      elif [[ "$result_tri" == "4" ]]; then
        echo "progr retourne $result_tri : Erreur inattendue..."
      fi
    fi
  fi
  if [[ "$tri" == "--tab" ]]; then
    if [[ "$h" == "ok" ]]; then
      echo "Tri des donnees d'altitude par TAB"
      result_tri=$(./progr -f altitude.txt -o h.txt -r --tab)
      if [[ "$result_tri" == "1" ]]; then
        echo "progr retourne $result_tri : Erreur sur options activees"
      elif [[ "$result_tri" == "2" ]]; then
        echo "progr retourne $result_tri : Erreur avec le fichier de donnees d'entree"
      elif [[ "$result_tri" == "3" ]]; then
        echo "progr retourne $result_tri : Erreur avec le fichier de donnees de sortie"
      elif [[ "$result_tri" == "4" ]]; then
        echo "progr retourne $result_tri : Erreur inattendue..."
      fi
    fi
    if [[ "$m" == "ok" ]]; then
      echo "Tri des donnees d'humidite par TAB"
      result_tri=$(./progr -f humidite.txt -o m.txt -r --tab)
      if [[ "$result_tri" == "1" ]]; then
        echo "progr retourne $result_tri : Erreur sur options activees"
      elif [[ "$result_tri" == "2" ]]; then
        echo "progr retourne $result_tri : Erreur avec le fichier de donnees d'entree"
      elif [[ "$result_tri" == "3" ]]; then
        echo "progr retourne $result_tri : Erreur avec le fichier de donnees de sortie"
      elif [[ "$result_tri" == "4" ]]; then
        echo "progr retourne $result_tri : Erreur inattendue..."
      fi
    fi
  fi
elif [[ "$tri" == "vide" ]]; then
  if [[ "$h" == "ok" ]]; then
    echo "Tri des donnees d'altitude par AVL"
    result_tri=$(./progr -f altitude.txt -o h.txt -r --avl)
    if [[ "$result_tri" == "1" ]]; then
      echo "progr retourne $result_tri : Erreur sur options activees"
    elif [[ "$result_tri" == "2" ]]; then
      echo "progr retourne $result_tri : Erreur avec le fichier de donnees d'entree"
    elif [[ "$result_tri" == "3" ]]; then
      echo "progr retourne $result_tri : Erreur avec le fichier de donnees de sortie"
    elif [[ "$result_tri" == "4" ]]; then
      echo "progr retourne $result_tri : Erreur inattendue..."
    fi
  fi
  if [[ "$m" == "ok" ]]; then
    echo "Tri des donnees d'humidite par AVL"
    result_tri=$(./progr -f humidite.txt -o m.txt -r --avl)
    if [[ "$result_tri" == "1" ]]; then
      echo "progr retourne $result_tri : Erreur sur options activees"
    elif [[ "$result_tri" == "2" ]]; then
      echo "progr retourne $result_tri : Erreur avec le fichier de donnees d'entree"
    elif [[ "$result_tri" == "3" ]]; then
      echo "progr retourne $result_tri : Erreur avec le fichier de donnees de sortie"
    elif [[ "$result_tri" == "4" ]]; then
      echo "progr retourne $result_tri : Erreur inattendue..."
    fi
  fi
fi
# ///////

# Remplacement de caractères de point décimal




# Exécution des commandes gnuPlot pour l'affichage des graphiques
echo "Execution des fenetres graphiques avec GnuPlot :"
gnuplot <<- EOF
  plot x*x
EOF
# ///////

# Suppression des fichiers temporaires
rm __tm* 2>/dev/null
echo "Fin du programme Bash"