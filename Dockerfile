FROM nginx
RUN rm /usr/share/nginx/html/index.html
COPY /public/ /usr/share/nginx/html
RUN ln -s /usr/share/nginx/html/index.htm /usr/share/nginx/html/index.php && sed -i -E 's|(text/html)([[:space:]]+)|\1\2php |g' /etc/nginx/mime.types
