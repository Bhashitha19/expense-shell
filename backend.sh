
log_file="/tmp/expense.log"
color="\e[33m"

echo -e "${color} Disable Nodejs Default Version \e[0m"
dnf module disable nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${clor} Enable Nodejs 18 Version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} Install Nodejs \e[0m"
dnf install nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} Copy Backend Service File \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

id expense &>>$log_file
if [ $? -ne 0 ]; then
  echo -e "${color} Add Application user \e[0m"
  useradd expense &>>$log_file
  if [ $? -eq 0 ]; then
   echo -e "\e[32m SUCCESS \e[0m"
   else
  echo -e "\e[31m FAILURE \e[0m"
   fi
fi

if [ -d /app ]; then
  echo -e "${color} create application directory \e[0m"
  useradd expense &>>$log_file
  if [ $? -eq 0 ]; then
   echo -e "\e[32m SUCCESS \e[0m"
   else
  echo -e "\e[31m FAILURE \e[0m"
   fi
fi

echo -e "${color} Delete old Application Content \e[0m"
rm -rf /app/* &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi


echo -e "${color} Download Application Content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} Extract Application Content \e[0m"
cd /app &>>$log_file
unzip /tmp/backend.zip &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} Download Nodejs Dependencies \e[0m"
npm install &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} Install mysql Client to Load Schema \e[0m"
dnf install mysql -y &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} Load Schema \e[0m"
mysql -h mysql-dev1.decops76s.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} starting Backend Service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
if [ $? -eq 0 ]; then
 echo -e "\e[32m SUCCESS \e[0m"
else
 echo -e "\e[31m FAILURE \e[0m"
fi


