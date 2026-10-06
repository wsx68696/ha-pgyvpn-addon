ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:21.0.7
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# 蒲公英官方客户端镜像。客户端二进制是为 Alpine/musl 构建的
# （interp=/lib/ld-musl-x86_64.so.1，链接 libc.musl-x86_64.so.1 + libstdc++.so.6），
# 所以可以整体迁移到官方基础镜像上，不需要 OpenRC 或 dpkg。
# 这里只把它当作「文件来源」，不继承它的 /etc 和 apk 状态。
# buildx 会按目标平台自动挑选对应架构的 manifest。
FROM bestoray/pgyvpn:2.4.0 AS vendor

# hadolint ignore=DL3006
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH
ARG BUILD_VERSION

# 1) 运行时依赖。两个客户端二进制的完整 DT_NEEDED 为：
#      libstdc++.so.6  libuuid.so.1  libgcc_s.so.1  libc.musl-x86_64.so.1
#    （libc.musl 由基础镜像的 musl 提供）
#      libstdc++ - libstdc++.so.6
#      libuuid   - libuuid.so.1      （Alpine 里不在 libstdc++ 的依赖里，必须显式装）
#      libgcc    - libgcc_s.so.1     （同上）
#      jq        - 解析 Supervisor 下发的 /data/options.json
#      bash      - s6 服务脚本使用 bash
#      procps    - pgrep/pidof
#      iproute2  - 用 `ip address` 检测 oray_vnc 网卡
#      nginx     - 提供 Ingress 管理页
#    不覆盖 /etc/apk/repositories：官方基础镜像自带与自身 ABI 匹配的 v3.24 源。
RUN \
    apk add --no-cache \
        bash \
        dmidecode \
        iproute2 \
        jq \
        libgcc \
        libstdc++ \
        libuuid \
        nginx \
        procps

# 2) 从 vendor 镜像迁移客户端。显式列出文件，避免把 vendor 的
#    /etc/oray 状态和 dpkg 数据库带进来。
COPY --from=vendor /usr/sbin/pgyvisitor /usr/sbin/pgyvisitor
COPY --from=vendor /usr/sbin/pgyvpn_svr /usr/sbin/pgyvpn_svr
COPY --from=vendor /usr/share/pgyvpn /usr/share/pgyvpn

# 可写目录：Supervisor 会把 /data 挂成持久卷
RUN \
    mkdir -p /data/pgyvpn /data/oray-log/pgyvpn /etc/oray/pgyvpn /var/log/oray/pgyvpn

# 3) 由 s6-overlay 管理服务，不再用 ENTRYPOINT 跑 shell 脚本
COPY rootfs /

# 先把烘焙进镜像的默认 config.ini 放进持久卷，再建立软链
RUN \
    cp -a /etc/oray/pgyvpn/config.ini /data/pgyvpn/config.ini \
    && ln -sfn /data/pgyvpn /etc/oray/pgyvpn \
    && ln -sfn /data/oray-log /var/log/oray \
    && chmod 0755 /usr/sbin/pgyvisitor /usr/sbin/pgyvpn_svr \
    && chmod 0755 /usr/share/pgyvpn/script/pgystart \
    && chmod 0755 /usr/share/pgyvpn/script/pgyvpn_monitor \
    && chmod 0755 \
        /etc/s6-overlay/s6-rc.d/pgyvpn/run \
        /etc/s6-overlay/s6-rc.d/pgyvpn-monitor/run \
        /etc/s6-overlay/s6-rc.d/nginx/run

EXPOSE 8099

LABEL \
    io.hass.name="蒲公英组网" \
    io.hass.description="让 Home Assistant OS 主机加入贝锐蒲公英虚拟网络" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    org.opencontainers.image.title="蒲公英组网" \
    org.opencontainers.image.description="让 Home Assistant OS 主机加入贝锐蒲公英虚拟网络" \
    org.opencontainers.image.source="https://github.com/wsx68696/ha-pgyvpn-addon" \
    org.opencontainers.image.licenses="MIT"
