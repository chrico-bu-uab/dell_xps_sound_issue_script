#!/bin/bash

# a script to do stuff with packages found with aptitude.

#SYMBOLS=$(echo {a..z} {A..Z} _ - {0..9})
TERMS="audio sound driver dell dummy output break card new device hdmi port"

function getPackages () {
  sudo aptitude search "$1" | shuf | cut -d" " -f3
#  echo "${1} ${RUNNING_LIST}" | sort -u
}

function hasString () {
  null=$(echo $1 | grep -q "$2")
  err=$? 
  if [ $err -eq 0 ]; then
    echo 1
  else
    echo 0
  fi
}

function install_packages () {
  for name in "$1"; do
    countHas=0
    desc=$(sudo aptitude show $name)
    for term in $TERMS; do
      has=$(hasString "$desc" $term)
      countHas=$((countHas+has))
    done
    if [ $countHas -gt 0 ]; then
      echo "$desc" | grep Conflicts
      echo $name
      sudo aptitude install $name
    fi
  done
}

function doit () {
  list=$(echo "$(getPackages $1):" | tr " " "\n" | cut -d":" -f1 | sort -u)
  echo "$list" | wc -l
  prev_name="wi4ewfzw3453reuer35FciorGQ342a656vc23gGSad"
  base_pkgs=
  for name in $list; do
    forComp=$(echo $name | rev | cut -c2- | rev)
    has=$(hasString "$forComp" "$prev_name")
    if [ $has -eq 0 ]; then
      echo "INCLUDE $name"
      base_pkgs="$base_pkgs $name"
      prev_name=$forComp
    else
      echo "EXCLUDE $name"
      sudo aptitude purge "$name"
    fi
  done
  install_packages "$base_pkgs"
#  echo "$base_pkgs" | tr " " "\n"
}

for term in $TERMS; do
  doit $term
done
