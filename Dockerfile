FROM abaez/luarocks

MAINTAINER [Alejandro Baez](https://twitter.com/a_baez)

# Dependencies
RUN yum install -y perl gcc-c++ pcre-devel deadline-devel openssl-devel curl

ENV OPENRESTY_VERSION 1.7.10.1

WORKDIR /tmp

# Download openresty
RUN curl -o openresty.tar.gz "http://openresty.org/download/ngx_openresty-$OPENRESTY_VERSION.tar.gz"

RUN tar zxf openresty.tar.gz && mv ngx_openresty-$OPENRESTY_VERSION openresty

WORKDIR /tmp/openresty

RUN ./configure

RUN make

RUN make install

WORKDIR /opt/openresty
