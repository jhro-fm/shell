#!/usr/bin/env bash
#
# author: jhro-fm
# date: 2019/10/15
# encoding: utf8
# usage:lnmp环境安装及配置yum安装


# 准备yum源, nginx源//mysql源//PHP7源,以.repo结尾的源文件;
# file: nginx.repo//mysql.repo//php7.repo
cp ./nginx.repo /etc/yum.repos.d/nginx.repo
cp ./mysql.repo /etc/yum.repos.d/mysql.repo
cp ./php7.repo /etc/yum.repos.d/php7.repo

# 安装nginx//mysql//php环境
yum -y install nginx mysql-community-server php php-fpm php-mysql php-devel php-mbstring php-mcrypt php-gd php-xml

# 配置配置文件
# nginx配置文件: /etc/nginx/conf.d/default.conf
# mysql配置文件: /etc/my.cnf
# php配置文件: /etc/php-fpm.d/www.conf
mv /etc/nginx/conf.d/{default.conf,default.conf.bak}
cp ./file/nginx.conf /etc/nginx/conf.d/default.conf

# 开启nginx/mysql/php-fpm服务
systemctl start nginx mysqld php-fpm && systemctl enable nginx mysqld php-fpm

# 修改密码: -e在命令行中编辑sql语句
# mysql的日志文件位置: /var/log/mysqld.log
passwd=$(grep 'temporary password' /var/log/mysqld.log | awk '{ print $NF }')
mysql --connect-expired-password -uroot -p"${passwd}" -e "alter user root@localhost identified by '(Hlions..1015)';"
mysql -uroot -p"(Hlions..1015)" -e "create database wordpress;"

# 设置连通性检查脚本
cp ./index.php /usr/share/nginx/html/index.php
#
