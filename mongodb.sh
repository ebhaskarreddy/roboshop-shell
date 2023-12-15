#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

VALIDATE(){
  if [ $1 -ne 0 ]
  then
    echo -e "$2...$R failed $N"
  else
    echo -e "$2..$G sucess $N"
  fi
}

if [ $ID -ne 0 ]
then
  echo "$R run the script ith root user $N"
  exit 1
else
  echo "$G YOU ARE ROOT USER $N"
fi

cp mongodb.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copy mongodb repo"
dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Remote access to MongoDB"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting MongoDB"