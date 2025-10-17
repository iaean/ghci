FROM node:22-alpine@sha256:dbcedd8aeab47fbc0f4dd4bffa55b7c3c729a707875968d467aaaea42d6225af

LABEL org.opencontainers.image.title="Alpine Node.js App"
LABEL org.opencontainers.image.description="Check GitHub CI with Alpine Node.js"
LABEL org.opencontainers.image.version=1.0.0

ENV VERSION=1.0.0

# provided via BuildKit
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

# defaults for none BuildKit
ARG _platform=${TARGETPLATFORM:-linux/amd64}
ARG _os=${TARGETOS:-linux}
ARG _arch=${TARGETARCH:-amd64}
ARG _variant=${TARGETVARIANT:-}

ENV NODE_HOME="/home/node"

RUN apk --update upgrade && \
    apk add --no-cache tini bash coreutils tzdata openssl ca-certificates curl busybox-extras && \
    rm -rf /var/cache/apk/* && \
    corepack enable

# Install dockerize
# https://github.com/powerman/dockerize doesn't enabled SHA digests for assets via GitHub API
#
ARG DCKRZ_LINUX_AMD64_SHA256=9239915df1cc59b4ad3927f9aad6a36ffc256d459cff9b073ae9d7f9c9149a03
ARG DCKRZ_LINUX_ARM64_SHA256=3a11c2f207151c304e8cf7aef060cf30ce8d56979b346329087f3a2c6b6055cb
ENV DCKRZ_VERSION="0.24.0"
RUN curl -fsSL https://github.com/powerman/dockerize/releases/download/v${DCKRZ_VERSION}/dockerize-v${DCKRZ_VERSION}-${_os}-${_arch}${_variant} > /dckrz && \
    chmod a+x /dckrz && \
    echo "${DCKRZ_LINUX_AMD64_SHA256} */dckrz" >> /dckrz.sha256 && \
    echo "${DCKRZ_LINUX_ARM64_SHA256} */dckrz" >> /dckrz.sha256 && \
    sha256sum -c /dckrz.sha256 2>/dev/null | grep 'OK$'

# Set environment variables
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000
ENV NODE_ENV=production

USER node
WORKDIR $NODE_HOME

COPY --chown=node:node . ${NODE_HOME}/

RUN if [ -n "$HTTP_PROXY" ]; then \
      echo "httpProxy: $HTTP_PROXY" >> ${NODE_HOME}/.yarnrc.yml; \
    fi && \
    if [ -n "$HTTPS_PROXY" ]; then \
      echo "httpsProxy: $HTTPS_PROXY" >> ${NODE_HOME}/.yarnrc.yml; \
    fi && \
    yarn install && rm -rf .yarn

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "yarn", "start" ]
