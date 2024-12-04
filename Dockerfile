FROM debian:latest

LABEL maintainer="Samuel Nogueira"
LABEL date="04/12/2024 - (DMY)"

RUN apt-get update && apt install -y wget build-essential git tree software-properties-common ufw &&\
    wget https://nginx.org/download/nginx-1.27.3.tar.gz &&\    
    wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.44/pcre2-10.44.tar.gz &&\
    wget https://www.zlib.net/zlib-1.3.1.tar.gz &&\
    wget https://github.com/quictls/openssl/archive/refs/tags/openssl-3.3.0-quic1.tar.gz &&\ 
    wget https://github.com/openssl/openssl/releases/download/openssl-3.4.0/openssl-3.4.0.tar.gz &&\
    tar -zxvf openssl-3.4.0.tar.gz &&\
    tar -zxvf openssl-3.3.0-quic1.tar.gz &&\
    tar -xzvf zlib-1.3.1.tar.gz &&\
    tar -xzvf pcre2-10.44.tar.gz &&\
    tar -zxvf nginx-1.27.3.tar.gz &&\
    rm -rf *.tar.gz

RUN cd nginx-1.27.3 && ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --with-debug --with-http_v3_module --with-cc-opt=-I../quictls/build/include --with-ld-opt=-L../quictls/build/lib --with-http_ssl_module --with-pcre=../pcre2-10.44 --with-zlib=../zlib-1.3.1 --with-openssl=../openssl-3.4.0 && make && make install

COPY nginx.conf /etc/nginx/nginx.conf
COPY certs/server.crt /etc/nginx/certs/server.crt
COPY certs/server.key /etc/nginx/certs/server.key

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

