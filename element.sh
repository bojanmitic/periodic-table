#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN() {
  if [[ -z $1 ]]
  then
    echo Please provide an element as an argument. 
  elif [[ $1 =~ ^[0-9]+$ ]]
  then
    FETCH_DATA $1 "atomic_number"

  elif [[ $1 = [A-Z] || $1 = [A-Z][a-z] ]]
  then
  FETCH_DATA $1 "symbol"

  else
    FETCH_DATA $1 "name"
  fi
}

FETCH_DATA() {
  ELEMENT_RESULT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE $2='$1'")
  if [[ -z $ELEMENT_RESULT ]]
  then
    echo I could not find that element in the database.
  else
    echo "$ELEMENT_RESULT" | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR SYMBOL BAR NAME BAR TYPE
    do
      FORMAT_RESULT $ATOMIC_NUMBER $NAME $SYMBOL $TYPE $ATOMIC_MASS $MELTING_POINT $BOILING_POINT
    done
  fi
}

FORMAT_RESULT() {
  # $1=atomic_number, $2=name, $3=symbol, $4=type, $5=atomic_mass, $6=melting_point_celsius $7=boiling_point_celsius
  echo "The element with atomic number $1 is $2 ($3). It's a $4, with a mass of $5 amu. $2 has a melting point of $6 celsius and a boiling point of $7 celsius."
}

MAIN $1
