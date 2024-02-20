#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

SERVICES=$($PSQL "Select * from services order by service_id")

MAIN_MENU() {
echo -e "\nHere are a list of offered services:"
echo "$SERVICES" | while read SERVICE_ID BAR NAME
do
  echo "$SERVICE_ID) $NAME"
done
read SERVICE_ID_SELECTED

SERVICE=$($PSQL "Select service_id from services where service_id = '$SERVICE_ID_SELECTED'")

if [[ -z $SERVICE ]]
  then
   echo "That is not a valid choice."
    MAIN_MENU
  else
    APPOINTMENT
fi
}

APPOINTMENT() {
  echo "Please input your phone number."
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "Select customer_id from customers where phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_ID ]]
    then
      echo "We do not have you recorded an existing user."
      echo "Please put in your name:"
      read CUSTOMER_NAME
      ADD_CUSTOMER=$($PSQL "INSERT INTO CUSTOMERS(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  CUSTOMER_ID=$($PSQL "Select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$($PSQL "Select name from customers where customer_id = '$CUSTOMER_ID'")

  echo "What time would you like your appointment?"
  read SERVICE_TIME

  ADD_APPOINTMENT=$($PSQL "INSERT INTO APPOINTMENTS(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE', '$SERVICE_TIME')")
  SELECTED_SERVICE_NAME=$($PSQL "Select name from services where service_id = '$SERVICE'")
  echo "I have put you down for a$SELECTED_SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}

MAIN_MENU
