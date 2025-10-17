FROM node:22-alpine@sha256:dbcedd8aeab47fbc0f4dd4bffa55b7c3c729a707875968d467aaaea42d6225af

ARG CONTAINER_USER=vscode
ARG NVM_VERSION=0.40.3
ARG GITHUB_CLI_VERSION=2.81.0
ARG GITLAB_CLI_VERSION=1.73.0

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

ENV BASH_ENV=/home/${CONTAINER_USER}/.bash_env
ENV NVM_VERSION=${NVM_VERSION}

RUN deluser --remove-home node && \
    apk add --no-cache curl gcompat bind-tools ca-certificates openssl ncurses coreutils python3 make gcc g++ libgcc linux-headers grep util-linux binutils findutils
RUN curl -L https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_${_os}_${_arch}${_variant}.tar.gz | tar -xz --strip-components=2 -C /usr/local/bin gh_${GITHUB_CLI_VERSION}_${_os}_${_arch}${_variant}/bin/gh && \
    chown root:root /usr/local/bin/gh && \
    curl -L https://gitlab.com/gitlab-org/cli/-/releases/v${GITLAB_CLI_VERSION}/downloads/glab_${GITLAB_CLI_VERSION}_${_os}_${_arch}${_variant}.tar.gz | tar -xz --strip-components=1 -C /usr/local/bin bin/glab && \
    chown root:root /usr/local/bin/glab
