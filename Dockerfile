FROM alpine
COPY . /store
ENTRYPOINT ["sh","/usr/store/entrypoint.sh"]