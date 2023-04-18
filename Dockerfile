FROM nginx:1.20.2
COPY nginx.conf /etc/nginx/nginx.conf.org
COPY health-check.conf netnegar.conf /etc/nginx/
ENV EXPOSED_PORT 443
ENV SERVER_NAME_DASHBOARD dashbrd-demo.opex.dev
ENV SERVER_NAME_ADMIN_PANEL adm-demo.opex.dev
ENV SERVER_NAME_WEB_APP demo.opex.dev
ENV SERVER_NAME_AUTH auth-demo.opex.dev
ENV SERVER_NAME_API api.opex.dev
ENV SERVER_NAME_KIBANA kibana-demo.opex.dev
ENV SERVER_NAME_GRAFANA grafana-demo.opex.dev
ENV SERVER_NAME_MOBILE_APP mobile-demo.opex.dev
ENTRYPOINT sh -c 'envsubst \
\$EXPOSED_PORT,\$SERVER_NAME_DASHBOARD,\$SERVER_NAME_ADMIN_PANEL,\$SERVER_NAME_WEB_APP,\$SERVER_NAME_AUTH,\$SERVER_NAME_API,\$SERVER_NAME_MOBILE_APP,\$SERVER_NAME_GRAFANA,\$SERVER_NAME_KIBANA \
< /etc/nginx/nginx.conf.org \
| tee /etc/nginx/nginx.conf \
&& nginx -g "daemon off;"'
EXPOSE 443
