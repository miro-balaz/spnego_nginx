FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget \
        tar \
        libssl-dev \
        build-essential \
        libkrb5-dev \
        krb5-user \
        libpcre3 libpcre3-dev \
	zlib1g-dev \
        git

WORKDIR /tmp

RUN wget http://nginx.org/download/nginx-1.18.0.tar.gz -O nginx.tar.gz && \
        mkdir /tmp/nginx && \
        tar -xzvf nginx.tar.gz -C /tmp/nginx --strip-components=1 &&\
        git clone https://github.com/stnoonan/spnego-http-auth-nginx-module.git nginx/spnego-http-auth-nginx-module

# Build Nginx
WORKDIR /tmp/nginx

RUN ./configure \
        --user=nginx \
        --with-debug \
        --group=nginx \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/run/nginx.pid \
        --lock-path=/run/lock/subsys/nginx \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-pcre \
        --with-file-aio \
        --with-ipv6 \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_auth_request_module \
        --add-module=spnego-http-auth-nginx-module && \
        make && \
        make install



CMD ["nginx", "-g", "daemon off;"] 