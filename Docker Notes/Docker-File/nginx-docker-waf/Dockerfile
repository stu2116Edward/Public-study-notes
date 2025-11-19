# FROM alpine:3.20 AS builder
FROM stu2116edwardhu/nginx:latest AS builder

# 可选手动传参，否则自动抓最新版
# ARG NGINX_VERSION
# # ARG OPENSSL_VERSION
# # ARG ZLIB_VERSION
# ARG CORERULESET_VERSION

WORKDIR /usr/src

# 安装构建依赖
RUN set -eux && apk add --no-cache \
    build-base \
    curl \
    git \
    bash \
    linux-headers \
    pcre-dev \
    pcre2 \
    pcre2-dev \
    zlib-dev \
    openssl-dev \
    libxml2-dev \
    libxslt-dev \
    yajl-dev \
    lmdb-dev \
    lua-dev \
    geoip-dev \
    brotli-dev \
    libtool \
    autoconf \
    automake \
    pkgconfig \
    perl \
    sed \
    grep \
    make \
    g++ \
    wget \
    && \
    # 各种组件的版本号获取 纯数字
    NGINX_VERSION=$(wget -q -O - https://nginx.org/en/download.html | grep -oE 'nginx-[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -d'-' -f2) \
    && \
    OPENSSL_VERSION=$(wget -q -O - https://www.openssl.org/source/ | grep -oE 'openssl-[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -d'-' -f2) \
    && \
    ZLIB_VERSION=$(wget -q -O - https://zlib.net/ | grep -oE 'zlib-[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -d'-' -f2) \
    && \
    ZSTD_VERSION=$(curl -Ls https://github.com/facebook/zstd/releases/latest | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -c2-) \
    && \
    CORERULESET_VERSION=$(curl -s https://api.github.com/repos/coreruleset/coreruleset/releases/latest | grep -oE '"tag_name": "[^"]+' | cut -d'"' -f4 | sed 's/v//') \
    && \
    # ModSecurity模块和ModSecurity-nginx模块
    git clone --depth 1 https://github.com/owasp-modsecurity/ModSecurity \
    && cd ModSecurity \
    && git submodule update --init --depth 1 \
    && ./build.sh \
    && ./configure \
    && make -j$(nproc) \
    && make install && \
    git clone https://github.com/owasp-modsecurity/ModSecurity-nginx \
    && cd ModSecurity-nginx \
    && cd .. && \
    # Br压缩模块
    git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli \
    && \
    # ZSTD压缩模块
    wget https://github.com/facebook/zstd/releases/download/v${ZSTD_VERSION}/zstd-${ZSTD_VERSION}.tar.gz \
    && tar -xzf zstd-${ZSTD_VERSION}.tar.gz \
    && cd zstd-${ZSTD_VERSION} \
    && make clean \
    && CFLAGS="-fPIC" make && make install \
    && cd .. \
    && \
    git clone --depth=10 https://github.com/tokers/zstd-nginx-module.git \
    && \
    \
    echo "=============版本号=============" && \
    echo "NGINX_VERSION=${NGINX_VERSION}" && \
    echo "OPENSSL_VERSION=${OPENSSL_VERSION}" && \
    echo "ZLIB_VERSION=${ZLIB_VERSION}" && \
    echo "ZSTD_VERSION=${ZSTD_VERSION}" && \
    echo "CORERULESET_VERSION=${CORERULESET_VERSION}" && \
    # \
    # # fallback 以防 curl/grep 失败
    # NGINX_VERSION="${NGINX_VERSION:-1.29.0}" && \
    # OPENSSL_VERSION="${OPENSSL_VERSION:-3.3.0}" && \
    # ZLIB_VERSION="${ZLIB_VERSION:-1.3.1}" && \
    # ZSTD_VERSION="${ZSTD_VERSION:-1.5.7}" && \
    # CORERULESET_VERSION="${CORERULESET_VERSION}" && \
    # \
    # echo "==> Using versions: nginx-${NGINX_VERSION}, openssl-${OPENSSL_VERSION}, zlib-${ZLIB_VERSION}" && \
    \
    # 下载需要的模块 填入版本号
    curl -fSL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o nginx.tar.gz && \
    tar xzf nginx.tar.gz && \
    \
    curl -fSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -o openssl.tar.gz && \
    tar xzf openssl.tar.gz && \
    \
    curl -fSL https://fossies.org/linux/misc/zlib-${ZLIB_VERSION}.tar.gz -o zlib.tar.gz && \
    tar xzf zlib.tar.gz && \
    \
    # 编译安装步骤
    cd nginx-${NGINX_VERSION} && \
    # ./configure \
    #   --prefix=/etc/nginx \
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
    # make install && \
    # strip /etc/nginx/sbin/nginx

    # 编译生成.so模块
    ./configure \
    --with-compat \
    --add-dynamic-module=../ngx_brotli \
    --add-dynamic-module=../ModSecurity-nginx \
    --add-dynamic-module=../zstd-nginx-module \
    && \
    make modules \
    # && mv /usr/src/nginx-${NGINX_VERSION} /usr/src/nginx
    && \
    # 查看未压缩前的大小
    du -sh /usr/local/modsecurity/lib && \
    strip /usr/local/modsecurity/lib/*.so* && \
    du -sh /usr/local/modsecurity/lib
    # du -sh /usr/src && \
    # find /usr/src/ -type f -name '*.so' -exec strip {} \; && \
    # du -sh /usr/src


    # ./configure \
    # --with-compat \
    # # --add-dynamic-module=../ngx_brotli \
    # --add-dynamic-module=../ModSecurity-nginx \
    # # --add-dynamic-module=../zstd-nginx-module \
    # && \
    # make -j$(nproc) && \
    # make install

# ✅ 最小运行镜像：Alpine + libmodsecurity 运行依赖
# FROM alpine:3.20 AS runtime
# FROM nginx:alpine
FROM stu2116edwardhu/nginx:latest

# 安装运行依赖
# RUN apk add --no-cache \
#     lua5.1 \
#     lua5.1-dev \
#     pcre \
#     pcre-dev \
#     yajl \
#     yajl-dev

# 拷贝构建产物
# COPY --from=builder /usr/src/nginx-${NGINX_VERSION}/objs/*.so /etc/nginx/modules/
# COPY --from=builder /usr/src/nginx-1.29.0/objs/*.so /etc/nginx/modules/
# COPY --from=builder /usr/src/nginx/objs/*.so /etc/nginx/modules/
COPY --from=builder /usr/local/modsecurity/lib/* /usr/lib/

# 环境变量指定动态库搜索路径
ENV LD_LIBRARY_PATH=/usr/local/modsecurity/lib

# 创建配置目录并下载必要文件
RUN set -eux \
    && apk add --no-cache lua5.1 lua5.1-dev pcre pcre-dev yajl yajl-dev curl \
    && mkdir -p /etc/nginx/modsec/plugins \
    && CORERULESET_VERSION=$(curl -s https://api.github.com/repos/coreruleset/coreruleset/releases/latest | grep -oE '"tag_name": "[^"]+' | cut -d'"' -f4 | sed 's/v//') \
    && wget https://github.com/coreruleset/coreruleset/archive/v${CORERULESET_VERSION}.tar.gz \
    && tar -xzf v${CORERULESET_VERSION}.tar.gz --strip-components=1 -C /etc/nginx/modsec \
    && rm -f v${CORERULESET_VERSION}.tar.gz \
    && wget -P /etc/nginx/modsec/plugins https://raw.githubusercontent.com/coreruleset/wordpress-rule-exclusions-plugin/master/plugins/wordpress-rule-exclusions-before.conf \
    && wget -P /etc/nginx/modsec/plugins https://raw.githubusercontent.com/coreruleset/wordpress-rule-exclusions-plugin/master/plugins/wordpress-rule-exclusions-config.conf \
    && wget -P /etc/nginx/modsec/plugins https://raw.githubusercontent.com/kejilion/nginx/main/waf/ldnmp-before.conf \
    && cp /etc/nginx/modsec/crs-setup.conf.example /etc/nginx/modsec/crs-setup.conf \
    && echo 'SecAction "id:900110, phase:1, pass, setvar:tx.inbound_anomaly_score_threshold=30, setvar:tx.outbound_anomaly_score_threshold=16"' >> /etc/nginx/modsec/crs-setup.conf \
    && wget https://raw.githubusercontent.com/owasp-modsecurity/ModSecurity/v3/master/modsecurity.conf-recommended -O /etc/nginx/modsec/modsecurity.conf \
    && sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf \
    && sed -i 's/SecPcreMatchLimit [0-9]\+/SecPcreMatchLimit 20000/' /etc/nginx/modsec/modsecurity.conf \
    && sed -i 's/SecPcreMatchLimitRecursion [0-9]\+/SecPcreMatchLimitRecursion 20000/' /etc/nginx/modsec/modsecurity.conf \
    && sed -i 's/^SecRequestBodyLimit\s\+[0-9]\+/SecRequestBodyLimit 52428800/' /etc/nginx/modsec/modsecurity.conf \
    && sed -i 's/^SecRequestBodyNoFilesLimit\s\+[0-9]\+/SecRequestBodyNoFilesLimit 524288/' /etc/nginx/modsec/modsecurity.conf \
    && sed -i 's/^SecAuditEngine RelevantOnly/SecAuditEngine Off/' /etc/nginx/modsec/modsecurity.conf \
    && echo 'Include /etc/nginx/modsec/crs-setup.conf' >> /etc/nginx/modsec/modsecurity.conf \
    && echo 'Include /etc/nginx/modsec/plugins/*-config.conf' >> /etc/nginx/modsec/modsecurity.conf \
    && echo 'Include /etc/nginx/modsec/plugins/*-before.conf' >> /etc/nginx/modsec/modsecurity.conf \
    && echo 'Include /etc/nginx/modsec/rules/*.conf' >> /etc/nginx/modsec/modsecurity.conf \
    && echo 'Include /etc/nginx/modsec/plugins/*-after.conf' >> /etc/nginx/modsec/modsecurity.conf \
    && ldconfig /usr/lib \
    && wget https://raw.githubusercontent.com/owasp-modsecurity/ModSecurity/v3/master/unicode.mapping -O /etc/nginx/modsec/unicode.mapping \
    && apk del curl \
    && rm -rf /var/cache/apk/*

EXPOSE 80 443
WORKDIR /etc/nginx
CMD ["/etc/nginx/sbin/nginx", "-g", "daemon off;"]
