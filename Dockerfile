FROM nginx
RUN rm /usr/share/nginx/html/index.html
COPY /public/ /usr/share/nginx/html
run ln -s /usr/share/nginx/html/index.htm /usr/share/nginx/html/index.php
COPY ["/Store Pictures/","/usr/share/nginx/html/Store Pictures/"]
