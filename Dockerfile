FROM nginx
RUN rm /usr/share/nginx/html/index.html
COPY /public/ /usr/share/nginx/html
COPY ["/Store Pictures/","/usr/share/nginx/html/Store Pictures/"]
