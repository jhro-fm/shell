
#!/usr/bin/env bash
#
# author: jhro-fm
# date: 2019/10/15
# encoding: utf8
# usage:lnmp环境安装及配置 源码安装 

#安装nginx
yum install -y pcre-devel zlib-devel openssl-devel wget gcc tree vim
wget http://nginx.org/download/nginx-1.12.2.tar.gz
tar -xzvf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --prefix=/usr/local/nginx --with-http_ssl_module
make && make install
/usr/local/nginx/sbin/nginx
echo $?


#安装MySQL
yum install -y cmake make gcc gcc-c++ bison ncurses ncurses-devel wget
wget https://downloads.mysql.com/archives/get/file/mysql-boost-5.7.18.tar.gz
groupadd mysql
useradd -M -s /sbin/nologin -r -g mysql mysql
mkdir -p /server/mysql
tar zxf mysql-boost-5.7.18.tar.gz -C /server/
cd /server/mysql-5.7.18/
mv boost/ /server/mysql
#cd mysql-5.7.18
cmake -DCMAKE_INSTALL_PREFIX=/server/mysql  -DMYSQL_DATADIR=/server/mysql/data -DSYSCONFDIR=/etc -DMYSQL_UNIX_ADDR=/server/mysql/mysql.sock -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_UNIX_ADDR=l -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/server/mysql/boost
make && make install
chown -R mysql:mysql /server/mysql/
mv /etc/my.cnf{,.bak}
touch  /etc/my.cnf
echo "[mysqld]
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
#default
user = mysql
basedir = /server/mysql
datadir = /server/mysql/data
port = 3306
pid-file = /server/mysql/data/mysql.pid
socket = /server/mysql/mysql.sock
character-set-server=utf8
[client]
socket = /server/mysql/mysql.sock" > /etc/my.cnf
grep chkconfig ./* -R  -color
cp /server/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
chkconfig --list mysqld
/server/mysql/bin/mysqld --initialize-insecure --user=mysql --basedir=/server/mysql --datadir=/server/mysql/data 
service mysqld restart
service mysqld restart
echo "export MYSQL_HOME=/server/mysql

export PATH=$PATH:$MYSQL_HOME/bin" >>  /etc/profile
source /etc/profile
ln -s /server/mysql/bin/* /usr/local/bin/
echo $?


#安装php  暂时yum安装
yum -y install php php-mysql php-fpm php-devel php-mbstring php-mcrypt php-gd php-xml
service php-fpm restart
echo $?
