FROM jboesl/docker-nginx-headers-more
ADD nginx.conf opex.dev.crt private.pem /etc/nginx/