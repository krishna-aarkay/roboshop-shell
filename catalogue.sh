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
        echo -e " $2 ... $R FAILED $N"
    else
        echo -e " $2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please install the packages using root only $N"
    exit 1
else
    echo -e "$G Hola:: You are root user $N"
fi

echo -e "ALL arguments passed::$G $@ $N"
echo -e "Total arguments passed::$G $# $N"

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabled old version of nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabled new version of nodejs"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installed new version of nodejs"

useradd roboshop &>> $LOGFILE
VALIDATE $? "User Added roboshop"

mkdir /app &>> $LOGFILE
VALIDATE $? "Created app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "Downloaded catalogue application"

cd /app  &>> $LOGFILE
unzip /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "extract catalogue zip file"

npm install  &>> $LOGFILE
VALIDATE $? "installed dependencies" 

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "copied catalogue service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "catalogue daemon reloaded" 

systemctl enable catalogue &>> $LOGFILE 
VALIDATE $? "catalogue service enabled" 

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "catalogue service started" 

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "mongodb repo created" 

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "installed mongodb client" 

mongo --host mongodb.aarkay.online </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "installed dependencies" 