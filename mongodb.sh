#!/bin/bash
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

cp mongo.repo /etc/yum.repos.d/ &>> $LOGFILE

VALIDATE $? "mongoDB repo created"




