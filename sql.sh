#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

# colours---create a variables syntax:"\e[31m"
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

#echo "Script started executing at : $TIMESTAMP"

# password authentication given by user(don't write on script)
#echo "Please enter DB password:"
#read -s mysql_root_password


VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi
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

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature

#mysql -h dbsql.nirmaladevops.cloud -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
#if [ $? -ne 0 ]
#then
 #   mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
  #  VALIDATE $? "MySQL Root password Setup"
#else
 #   echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
#fi
