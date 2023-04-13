#!bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then

#define o usuário e o grupo do diretório /var/lib/mysql como mysql. Isso garante que o servidor 
#MySQL tenha permissão para escrever e acessar o diretório.

        chown -R mysql:mysql /var/lib/mysql

echo "MariaDB instalamos o mysql "
        # init database
        mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

#se correr mal , Winston, we have a problem  
        tfile=`mktemp`
        if [ ! -f "$tfile" ]; then
                echo "Winston, we have a problem "
                return 1
        fi
fi


#exclui qualquer usuário com o nome de usuário "root" que não esteja conectando-se de localhost, 
#127.0.0.1 ou ::1. Isso é feito por razões de segurança para evitar conexões de usuários não autorizados.

#exclui quaisquer usuários sem nome de usuário e exclui o banco de dados test, 
#que é um banco de dados de exemplo que normalmente é instalado com o MySQL.

if [ ! -d "/var/lib/mysql/wordpress" ]; then

        cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM     mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${USER_LOGIN}'@'%' IDENTIFIED by '${USER_PASSWORD}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${USER_LOGIN}'@'%';
FLUSH PRIVILEGES;
EOF
echo "MariaDB executamos o build ..."        
/usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
rm -f /tmp/create_db.sql
fi