FROM nginx
COPY /public/ /usr/share/nginx/html
COPY "/Store Pictures/" "/usr/share/nginx/html/Store Pictures/"
