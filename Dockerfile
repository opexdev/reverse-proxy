FROM nginx:1.20.2
COPY nginx.conf /etc/nginx/nginx.conf.org
ENV EXPOSED_PORT 443
ENTRYPOINT sh -c 'envsubst \$EXPOSED_PORT < /etc/nginx/nginx.conf.org | tee /etc/nginx/nginx.conf && nginx -g "daemon off;"'
EXPOSE 443
