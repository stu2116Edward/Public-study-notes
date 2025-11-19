# FROM alpine:3.20 AS builder
FROM alpine:latest AS builder

WORKDIR /build

# 安装构建依赖
RUN  set -eux && apk add --no-cache \
    build-base \
    curl \
    pcre-dev \
    zlib-dev \
    linux-headers \
    perl \
    sed \
    grep \
    tar \
    bash \
    jq \
    git \
    autoconf \
    automake \
    libtool \
    make \
    gcc \
    g++ \
    tree \
    && \
    # OPENRESTY_VERSION=$(wget --timeout 10 -q -O - https://openresty.org/en/download.html | grep -oE 'openresty-[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -d'-' -f2) \
    OPENRESTY_VERSION=$(wget --timeout=10 -q -O - https://openresty.org/en/download.html \
    | grep -ioE 'openresty [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' \
    | head -n1 \
    | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+') \
    && \
    OPENSSL_VERSION=$(wget -q -O - https://www.openssl.org/source/ | grep -oE 'openssl-[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -d'-' -f2) \
    && \
    ZLIB_VERSION=$(wget -q -O - https://zlib.net/ | grep -oE 'zlib-[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -d'-' -f2) \
    && \
    ZSTD_VERSION=$(curl -Ls https://github.com/facebook/zstd/releases/latest | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -c2-) \
    && \
    CORERULESET_VERSION=$(curl -s https://api.github.com/repos/coreruleset/coreruleset/releases/latest | grep -oE '"tag_name": "[^"]+' | cut -d'"' -f4 | sed 's/v//') \
    && \
    PCRE_VERSION=$(curl -sL https://sourceforge.net/projects/pcre/files/pcre/ \
    | grep -oE 'pcre/[0-9]+\.[0-9]+/' \
    | grep -oE '[0-9]+\.[0-9]+' \
    | sort -Vr \
    | head -n1) \
    && \
    echo "=============版本号=============" && \
    echo "OPENRESTY_VERSION=${OPENRESTY_VERSION}" && \
    echo "OPENSSL_VERSION=${OPENSSL_VERSION}" && \
    echo "ZLIB_VERSION=${ZLIB_VERSION}" && \
    echo "ZSTD_VERSION=${ZSTD_VERSION}" && \
    echo "CORERULESET_VERSION=${CORERULESET_VERSION}" && \
    echo "PCRE_VERSION=${CORERULESET_VERSION}" && \
    \
    # fallback 以防 curl/grep 失败
    OPENRESTY_VERSION="${OPENRESTY_VERSION:-1.21.4.1}" && \
    OPENSSL_VERSION="${OPENSSL_VERSION:-3.3.0}" && \
    ZLIB_VERSION="${ZLIB_VERSION:-1.3.1}" && \
    ZSTD_VERSION="${ZSTD_VERSION:-1.5.7}" && \
    CORERULESET_VERSION="${CORERULESET_VERSION:-4.15.0}" && \
    PCRE_VERSION="${PCRE_VERSION:-8.45}" && \
    \
    echo "==> Using versions: openresty-${OPENRESTY_VERSION}, openssl-${OPENSSL_VERSION}, zlib-${ZLIB_VERSION}, ZSTD_VERSION-${ZSTD_VERSION}, CORERULESET_VERSION-${CORERULESET_VERSION}, CORERULESET_VERSION-${CORERULESET_VERSION}" && \
    \
    curl -fSL https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz -o openresty.tar.gz && \
    # curl -fSL https://github.com/openresty/openresty/releases/download/v${OPENRESTY_VERSION}/openresty-${OPENRESTY_VERSION}.tar.gz  && \
    tar xzf openresty.tar.gz && \
    \
    curl -fSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -o openssl.tar.gz && \
    tar xzf openssl.tar.gz && \
    \
    curl -fSL https://fossies.org/linux/misc/zlib-${ZLIB_VERSION}.tar.gz -o zlib.tar.gz && \
    tar xzf zlib.tar.gz && \
    \
    curl -fSL https://sourceforge.net/projects/pcre/files/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz/download -o pcre.tar.gz && \
    tar xzf pcre.tar.gz && \
    \
    # tree \
    # && \
  
    # cd openresty-${OPENRESTY_VERSION} && \
    # ./configure \
    #   --prefix=/etc/openresty \
    #   --user=root \
    #   --group=root \
    #   --with-cc-opt="-static -static-libgcc" \
    #   --with-ld-opt="-static" \
    #   --with-openssl=../openssl-${OPENSSL_VERSION} \
    #   --with-zlib=../zlib-${ZLIB_VERSION} \
    #   --with-pcre \
    #   --with-pcre-jit \
    #   --with-http_ssl_module \
    #   --with-http_v2_module \
    #   --with-http_gzip_static_module \
    #   --with-http_stub_status_module \
    #   --without-http_rewrite_module \
    #   --without-http_auth_basic_module \
    #   --with-threads && \
    # make -j$(nproc) && \
    # make install \
  
    cd openresty-${OPENRESTY_VERSION} && \
    ./configure \
    --prefix=/usr/local \
    --modules-path=/usr/local/nginx/modules \
    --sbin-path=/usr/local/nginx/sbin/nginx \
    --conf-path=/usr/local/nginx/conf/nginx.conf \
    --error-log-path=/data/logs/error.log \
    --http-log-path=/data/logs/access.log \
    # --with-cc-opt="-static -O3 -DNGX_LUA_ABORT_AT_PANIC -static-libgcc" \
    # --with-ld-opt="-static -Wl,--export-dynamic" \
    --with-cc-opt="-O3 -DNGX_LUA_ABORT_AT_PANIC" \
    --with-ld-opt="-Wl,--export-dynamic" \
    --with-openssl=../openssl-${OPENSSL_VERSION} \
    --with-zlib=../zlib-${ZLIB_VERSION} \
    --with-pcre=../pcre-${PCRE_VERSION} \
    --with-pcre-jit \
    --with-stream \
    --user=nobody \
    --group=nobody \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-http_v2_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --with-http_stub_status_module  \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --with-http_sub_module \
    --with-http_gunzip_module \
    --with-threads \
    --with-compat \
    --with-stream=dynamic \
    --with-http_ssl_module \
    # --with-debug \
    # --with-lua_resty_core \
    # --with-lua_resty_lrucache \
    # --with-lua_resty_lock \
    # --without-lua_resty_dns \
    # --without-lua_resty_memcached \
    # --without-lua_redis_parser \
    # --without-lua_rds_parser \
    # --without-lua_resty_redis \
    # --without-lua_resty_mysql \
    # --without-lua_resty_upload \
    # --without-lua_resty_upstream_healthcheck \
    # --without-lua_resty_string \
    # --without-lua_resty_websocket \
    # --without-lua_resty_limit_traffic \
    # --without-lua_resty_lrucache \
    # --without-lua_resty_lock \
    # --without-lua_resty_signal \
    # --without-lua_resty_lrucache \
    # --without-lua_resty_shell \
    # --without-lua_resty_core \
    # --without-select_module \
    # --without-lua_resty_mysql \
    # --without-http_charset_module \
    # --without-http_ssi_module \
    # --without-http_userid_module \
    # --without-http_auth_basic_module \
    # --without-http_mirror_module \
    # --without-http_autoindex_module \
    # --without-http_split_clients_module \
    # --without-http_memcached_module \
    # --without-http_empty_gif_module \
    # --without-http_browser_module \
    # --without-stream_limit_conn_module \
    # --without-stream_geo_module \
    # --without-stream_map_module \
    # --without-stream_split_clients_module \
    # --without-stream_return_module \

    # cd openresty-${OPENRESTY_VERSION} && \
    # ./configure \
    # --prefix=/usr/local/openresty \
    # --with-luajit \
    # --with-pcre-jit \
    # --with-ipv6 \
    # --with-http_ssl_module \
    # --with-http_realip_module \
    # --with-http_addition_module \
    # --with-http_sub_module \
    # --with-http_dav_module \
    # --with-http_flv_module \
    # --with-http_mp4_module \
    # --with-http_gunzip_module \
    # --with-http_gzip_static_module \
    # --with-http_auth_request_module \
    # --with-http_random_index_module \
    # --with-http_secure_link_module \
    # --with-http_stub_status_module \
    # --with-http_v2_module \
    # --with-stream \
    # --with-stream_ssl_module \
    # --with-stream_ssl_preread_module \
    # --with-stream_realip_module \
    # --with-threads \
    # --with-file-aio
    
    && \
    make -j$(nproc) && \
    make install \
    && \
    # strip /usr/local/nginx/sbin/nginx
    strip /usr/local/nginx/sbin/nginx && \
    strip /usr/local/luajit/bin/luajit || true && \
    strip /usr/local/luajit/lib/libluajit-5.1.so.2 || true && \
    find /usr/local/nginx/modules -name '*.so' -exec strip {} \; || true && \
    find /usr/local/lualib -name '*.so' -exec strip {} \; || true

FROM alpine:latest

RUN apk add --no-cache libgcc

# 复制之前编译好的 openresty, luajit 等文件
COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /usr/local/luajit /usr/local/luajit
COPY --from=builder /usr/local/lualib /usr/local/lualib
COPY --from=builder /usr/local/bin/openresty /usr/local/bin/
COPY --from=builder /usr/local/luajit/bin/luajit /usr/local/bin/

# 软连接库路径等操作
RUN mkdir -p /usr/local/lib \
    && ln -sf /usr/local/luajit/lib/libluajit-5.1.so.2 /usr/local/lib/ \
    && ln -sf /usr/local/luajit/lib/libluajit-5.1.so.2.1.ROLLING /usr/local/lib/

ENV PATH="/usr/local/nginx/sbin:/usr/local/bin:$PATH"
ENV LUA_PATH="/usr/local/lualib/?.lua;;"
ENV LUA_CPATH="/usr/local/lualib/?.so;;"
ENV LD_LIBRARY_PATH="/usr/local/luajit/lib:$LD_LIBRARY_PATH"

WORKDIR /usr/local/nginx

RUN mkdir -p /data/logs && chown -R nobody:nobody /data/logs /usr/local/nginx

USER nobody

CMD ["nginx", "-g", "daemon off;"]
