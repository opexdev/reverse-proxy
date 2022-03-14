FROM nginx:1.20.2
ADD nginx.conf opex.dev.crt private.pem /etc/nginx/
