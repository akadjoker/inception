FROM alpine:3.16

ARG DB_NAME \
    USER_LOGIN \
    USER_PASSWORD

RUN apk update && apk add --no-cache mariadb mariadb-client 


#desativação do cache de host e resolução de nome e a configuração do endereço IP do servidor 
#MariaDB para "0.0.0.0", o que significa que o servidor MariaDB estará disponível em todas as interfaces de rede.


RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY ./requirements/mariadb/conf/create_db.sh .
RUN sh create_db.sh && rm create_db.sh
USER mysql
CMD ["/usr/bin/mysqld", "--skip-log-error"]