ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG BUILD_VERSION

# The upstream image is Alpine based. jq reads Supervisor options JSON
# without shell-escaping credentials into a generated command.
RUN printf '%s\n' \
      'https://dl-cdn.alpinelinux.org/alpine/latest-stable/main' \
      'https://dl-cdn.alpinelinux.org/alpine/latest-stable/community' \
      > /etc/apk/repositories \
    && apk add --no-cache jq

COPY run.sh /
RUN chmod 0755 /run.sh

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="app" \
  io.hass.arch="${BUILD_ARCH}"

ENTRYPOINT ["/run.sh"]
