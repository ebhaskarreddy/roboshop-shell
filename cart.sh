#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
  if [ $1 -ne 0 ]
  then
    echo "$2..$R failed $N"
  else
    echo "$2..$G succcess $N"
  fi
  }

if [ $ID -ne 0 ]
then
  echo "$R ERROR :: run the script with root user $N"
  exit 1
else
  echo "$G your are a root user $N"
fi

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "disabling current nodejs"

dnf module enable nodejs:18 -y  &>> $LOGFILE

VALIDATE $? "Enabling NodeJS:18"

dnf install nodejs -y  &>> $LOGFILE

VALIDATE $? "Installing NodeJS:18"

id roboshop

  if [ $? -ne 0 ]
  then
    useradd robshop
    VALIDATE $? "creation of user"
  else
    echo -e "roboshop user already exist $Y skiping $N"
  fi

mkdir /app

VALIDATE $? "creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip

VALIDATE $? "downloading cart application"

cd /app

unzip -o /tmp/cart.zip  &>> $LOGFILE

VALIDATE $? "unzipping cart"

npm install  &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp cart.service /etc/systemd/system/cart.service &> $LOGFILE

systemctl daemon-reload

VALIDATE $? "cart daemon reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enable cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting cart"
