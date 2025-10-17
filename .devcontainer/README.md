A Node.js [Dev Container][0] based on Alpine for [VS Code][1]. Microsoft provides a spec for [`.devcontainer`][2].

We are using `docker compose` for better environment injection.

 The [`common-utils`][6] feature is applied as it supports Alpine. We installed [`nvm`][3] but are not using it. As there is no Alpine binary package from [Node.js][4], `nvm` always try to compile `node` during install. This is also the reason why we utilize [`node:alpine`][5] as base image from DockerHub instead of the Alpine base image from Microsoft. Today the [node][7] feature doesn't support Alpine unfortunately.

The `vscode` container user UID is set to your local UID automatically. If you have problems with bind mounts check if your local UID exists in the container and are assigned to other users.

Injecting your host local `.gitconfig` into the container automatically is disabled by default for better segregation.

Create a `.devcontainer/devcontainer.env` file to inject variables into build and runtime context.

```bash
# HTTP_PROXY=
# HTTPS_PROXY=
# NO_PROXY=
# http_proxy=
# https_proxy=
# no_proxy=

# GIT_AUTHOR_NAME=
# GIT_COMMITTER_NAME=

# GITHUB_TOKEN=
# GITLAB_TOKEN=
```

[0]: https://code.visualstudio.com/docs/devcontainers/containers
[1]: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
[2]: https://containers.dev
[3]: https://github.com/nvm-sh/nvm
[4]: https://nodejs.org/en/download
[5]: https://github.com/nodejs/docker-node
[6]: https://github.com/devcontainers/features/tree/main/src/common-utils
[7]: https://github.com/devcontainers/features/tree/main/src/node