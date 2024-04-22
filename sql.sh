#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%s)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

# colours---create a variables syntax:"\e[31m"
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

echo "Script started executing at : $TIMESTAMP"


if [ $USERID -ne 0 ]
then
echo "Please run the script with root access"
exit 1
else
echo "super admin"
fi

VALIDATE(){
    #echo "exit status: $1"
    #echo "what are you doing : $2"
    if [ $1 -ne 0 ]
    then
    echo -e "$2......$R FAILURE $N" # -e to apply colours
    exit 1
    else
    echo -e "$2.......$G SUCCESS $N"
    fi

}
# end of the common code....

#start script file od mysql

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "start the mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "set the root password"
