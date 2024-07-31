#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~~~~ Number Guessing Game ~~~~~~\n"
echo -e "\nEnter your username"
read USERNAME

#get user_id
USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")
if [[ -z $USER_ID ]]
then
  INSERT_USER_RESULT=$($PSQL "insert into users(username) values ('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  USER_INFO=$($PSQL "select games_played, best_game from users where user_id=$USER_ID ")
  echo "$USER_INFO"| while IFS="|" read GAMES_PLAYED BEST_GAME
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

# GAME
GAME_WON=false
GUESS_COUNT=0
  # random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
echo -e "\nGuess the secret number between 1 and 1000:"

while [[ $GAME_WON == false ]]
do 
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
  else
    (( GUESS_COUNT++ ))
    if (( GUESS > SECRET_NUMBER ))
    then
      echo -e "\nIt's lower than that, guess again:"
    elif (( GUESS < SECRET_NUMBER ))
    then
      echo -e "\nIt's higher than that, guess again:"
    else
      GAME_WON=true
    fi
  fi
done

  echo -e "\nYou guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

