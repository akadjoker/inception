#!/bin/bash


echo "Nginx: criamos a key e cert lrosa-do  ...";

#    "req": indica que o comando será usado para gerar uma solicitação de assinatura de certificado ou um certificado autoassinado.
#    "-x509": indica que o comando será usado para gerar um certificado autoassinado.
#    "-nodes": indica que a chave privada não será criptografada com uma senha.
#    "-days 365": define a validade do certificado em dias.
#    "-newkey rsa:4096": gera uma nova chave privada RSA de 4096 bits.
#    "-keyout": especifica o caminho para o arquivo da chave privada.
#    "-out": especifica o caminho para o arquivo do certificado.
#    "-subj": especifica o assunto do certificado, incluindo o nome comum (CN) do domínio.

openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout nginx.key -out nginx.crt -subj "/C=PT/ST=Barreiro/L=Lisboa/CN=lrosa-do.42.fr";




