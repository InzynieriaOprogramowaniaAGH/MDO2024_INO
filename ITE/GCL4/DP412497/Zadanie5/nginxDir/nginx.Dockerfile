FROM nginx:alpine
# COPY my-nginx-config.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html