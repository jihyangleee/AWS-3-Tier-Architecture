yum update -y
yum install  -y httpd
systemctl start httpd
systemctl enable httpd
echo "Terraform Tutorial $(hostname -f)" > /var/www/html/index.html