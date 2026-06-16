FROM really/nginx-modsecurity:latest
USER root
# Install envsubst safely from the same Alpine version
RUN apk add --no-cache gettext

# nginx template
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# ModSecurity configuration
COPY ./modsecurity/ /etc/nginx/modsecurity/

# Lua scripts (if you need them)
COPY ./lua/ /etc/nginx/lua/

COPY ./health-check.conf /etc/nginx/health-check.conf

# Startup script
COPY entrypoint.sh /entrypoint.sh


RUN sed -i 's/\r$//' /entrypoint.sh \
    && chmod +x /entrypoint.sh \

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 443