FROM nginx:1.20.2
COPY nginx.conf /etc/nginx/nginx.conf.org
COPY health-check.conf netnegar.conf /etc/nginx/
ENV EXPOSED_PORT 443
ENV SERVER_NAME_DASHBOARD dashboard.opex.dev
ENV SERVER_NAME_ADMIN_PANEL admin.opex.dev
ENV SERVER_NAME_WEB_APP app.opex.dev
ENV SERVER_NAME_AUTH auth.opex.dev
ENV SERVER_NAME_HEALTH health.opex.dev
ENV SERVER_NAME_API api.opex.dev
ENV SERVER_NAME_KIBANA kibana.opex.dev
ENV SERVER_NAME_GRAFANA grafana.opex.dev
ENV SERVER_NAME_MOBILE_APP mobile.opex.dev
ENTRYPOINT sh -c 'envsubst \
\$EXPOSED_PORT,\$SERVER_NAME_DASHBOARD,\$SERVER_NAME_ADMIN_PANEL,\$SERVER_NAME_WEB_APP,\$SERVER_NAME_AUTH,\$SERVER_NAME_HEALTH,\$SERVER_NAME_API,\$SERVER_NAME_MOBILE_APP,\$SERVER_NAME_GRAFANA,\$SERVER_NAME_KIBANA \
< /etc/nginx/nginx.conf.org \
| tee /etc/nginx/nginx.conf \
&& nginx -g "daemon off;"'
EXPOSE 443
