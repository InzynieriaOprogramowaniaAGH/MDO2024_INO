FROM nginx

RUN mkdir -p /var/www/html/
COPY index.html /var/www/html/index.html

RUN mkdir -p /etc/nginx/ssl/ && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443