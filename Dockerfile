FROM nginx:1.20.2
COPY nginx.conf /etc/nginx/
ARG EXPOSED_PORT=443
ENV EXPOSED_PORT $EXPOSED_PORT
RUN envsubst '\$EXPOSED_PORT' < /etc/nginx/nginx.conf | tee /etc/nginx/nginx.conf
EXPOSE 443
