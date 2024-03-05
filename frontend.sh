echo -e "\e[36m installing Nginx \e[0m"
dnf install nginx -y &>>/tmp/expense.log

echo -e "\e[36m Copy Expense Config file \e[0m"
cp expense.conf /etc/Nginx/default.d/expense.conf &>>/tmp/expense.log

echo -e "\e[36m Clean old Nginx Content \e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/expense.log

echo -e "\e[36m Download Frontend Application Code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/expense.log

echo -e "\e[36m Extract Downloaded Application Content \e[0m"
cd /usr/share/nginx/html &>>/tmp/expense.log
unzip /tmp/frontend.zip &>>/tmp/expense.log

echo -e "\e[36m Starting Nginx Service \e[0m"
systemctl enable nginx &>>/tmp/expense.log
systemctl restart nginx &>>/tmp/expense.log