# Statische Auslieferung des Funnels für Coolify (Build Pack: Dockerfile).
FROM nginx:alpine

# Eigene nginx-Config (mit /h/<id>-Fallback) + die Funnel-Datei.
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
# nginx läuft im Vordergrund (Standard-CMD des Base-Images).
