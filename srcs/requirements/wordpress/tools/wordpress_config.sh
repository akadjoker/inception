#!bin/sh


chown -R 755 /var/www/*;


if [ ! -f "/var/www/done" ]; then
cat << EOF > /var/www/wp-config.php
<?php
define( 'DB_NAME', '${DB_NAME}' );
define( 'DB_USER', '${USER_LOGIN}' );
define( 'DB_PASSWORD', '${USER_PASSWORD}' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define('FS_METHOD','direct');
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );}
require_once ABSPATH . 'wp-settings.php';
EOF



	echo "WordPress está sendo configurado ..."
	mkdir -p /var/www/html
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
	chmod +x wp-cli.phar; 
	mv wp-cli.phar /usr/local/bin/wp;
	cd /var/www/html;

	echo "WordPress baixamos o wordpress "
	wp core download --allow-root;
	mv /var/www/wp-config.php /var/www/html/

	echo "WordPress criamos o ADMIN : ${ADMIN_LOGIN} "
	wp core install --allow-root --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${ADMIN_LOGIN} --admin_password=${ADMIN_PASSWORD} --admin_email=${ADMIN_EMAIL}
   
    echo "WordPress criamos o USER: ${USER_LOGIN} "
	wp user create --allow-root ${USER_LOGIN} ${USER_EMAIL} --user_pass=${USER_PASSWORD};

	#wp plugin install pretty-link --activate --allow-root
	#ste plugin é usado para otimizar o desempenho do site WordPress, armazenando em cache páginas e postagens
	wp plugin install wp-super-cache --activate --allow-root

	wp post create --allow-root --user=${ADMIN_LOGIN} --post_type=post --post_title='Este meu Post feito no config :D' --post_content='Tenho que pensar em algo bom para dizer ou nao' --post_status=publish
	wp post create --allow-root --user=${ADMIN_LOGIN} --post_type=post --post_title='Mais um post ' --post_content='assim da mais pica, ver um monte de postes :D' --post_status=publish
	wp post create --allow-root --user=${ADMIN_LOGIN}  --post_type=post --post_title='Projeto complicado este ' --post_content='a 42 a fazer me velho :( ' --post_status=publish

#os users precisam estar registrados e conectados para poder comentar em posts do WordPress
	wp option update comment_registration 1 --allow-root
#os comentários não serão moderados antes de serem publicados	
	wp option update comment_moderation 0 --allow-root
# os comentários não precisam ser aprovados antes de serem publicados
#apenas se estiverem em uma lista de comentários permitidos
	wp option update comment_whitelist 0 --allow-root


	echo "WordPress foi configurado com sucesso, eu espero :O "
	echo "done" > /var/www/done
else
echo "WordPress ja configurado com sucesso :) "
fi


echo "Starting PHP-FPM..."
exec "$@"
