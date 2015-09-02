FROM abaez/luarocks

MAINTAINER [Alejandro Baez](https://twitter.com/a_baez)

# Dependencies
RUN yum install -y perl gcc-c++ pcre-devel readline-devel openssl-devel curl

ENV OPENRESTY_VERSION 1.9.3.1
ENV OPENRESTY_PREFIX /opt/openresty
ENV NGINX_PREFIX /opt/openresty/nginx
ENV VAR_PREFIX /var/nginx

# Download openresty
WORKDIR /tmp
RUN curl -o openresty.tar.gz \
  "http://openresty.org/download/ngx_openresty-$OPENRESTY_VERSION.tar.gz"

RUN tar zxf openresty.tar.gz && mv ngx_openresty-$OPENRESTY_VERSION openresty

# Build openresty
WORKDIR /tmp/openresty
RUN ./configure \
  --prefix=$OPENRESTY_PREFIX \
  --http-client-body-temp-path=$VAR_PREFIX/client_body_temp \
  --http-proxy-temp-path=$VAR_PREFIX/proxy_temp \
  --http-log-path=$VAR_PREFIX/access.log \
  --error-log-path=$VAR_PREFIX/error.log \
  --pid-path=$VAR_PREFIX/nginx.pid \
  --lock-path=$VAR_PREFIX/nginx.lock \
  --with-luajit \
  --with-pcre-jit \
  --with-ipv6 \
  --with-http_ssl_module \
  --without-http_ssi_module \
  --without-http_userid_module \
  --without-http_fastcgi_module \
  --without-http_uwsgi_module \
  --without-http_scgi_module \
  --without-http_memcached_module \
  -j$(nproc)

RUN make -j$(nproc)
RUN make install

# Link openresty configuration
RUN ln -sf $NGINX_PREFIX/sbin/nginx /usr/local/bin/nginx \
 && ln -sf $NGINX_PREFIX/sbin/nginx /usr/local/bin/openresty \
 && ln -sf $OPENRESTY_PREFIX/bin/resty /usr/local/bin/resty \
 && ln -sf $OPENRESTY_PREFIX/luajit/bin/luajit-* $OPENRESTY_PREFIX/luajit/bin/lua \
 && ln -sf $OPENRESTY_PREFIX/luajit/bin/luajit-* /usr/local/bin/lua

WORKDIR $NGINX_PREFIX/

RUN rm -rf /tmp/openresty

ONBUILD RUN rm -rf conf/* html/*
ONBUILD COPY nginx $NGINX_PREFIX/

CMD ["nginx", "-g", "daemon off; error_log /dev/stderr info;"]
