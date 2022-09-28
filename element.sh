#!/bin/bash

# database boiler plate for doing queries with the periodic_table database
PSQL="psql -X --username freecodecamp --dbname periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # checks if input is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # does query based on element atomic number
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number='$1'")
  else
    # checks if input is an element symbol
    if [[ $1 =~ ^[a-Z]{1,2}$ ]]
    then
    # does query based on element symbol
      ELEMENT_INFO=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1'")
    else
    # defaults to element name for doing the query
      ELEMENT_INFO=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$1'")
    fi
  fi
  # checks if returns for any of the cases resulted in failure
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    # formats final response to comply with the expected output
    echo "$ELEMENT_INFO" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
