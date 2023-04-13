FROM alpine:3.16

ARG DOMAIN_NAME

RUN	apk update && apk upgrade && apk add --no-cache nginx  
EXPOSE 443

COPY ./requirements/nginx/tools/nginx.crt /etc/nginx/ssl/ 
COPY ./requirements/nginx/tools/nginx.key /etc/nginx/ssl/ 
COPY ./requirements/nginx/conf/nginx.conf /etc/nginx/http.d

      #- ./requirements/nginx/conf/:/etc/nginx/http.d/
      #- ./requirements/nginx/tools:/etc/nginx/ssl/


CMD ["nginx", "-g", "daemon off;"]