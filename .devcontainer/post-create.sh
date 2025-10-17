#!/bin/bash

# Create a script file sourced by both interactive and non-interactive bash shells
touch "${BASH_ENV}"
echo '. "${BASH_ENV}"' >> $HOME/.bashrc

# Manual nvm install avoids node auto install
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout v${NVM_VERSION}
) && \. "$NVM_DIR/nvm.sh" --no-use # Make use explicit

echo "system" > "$HOME/.nvmrc"
nvm alias default system
nvm use system
sudo corepack enable

cat <<EOT >> "${BASH_ENV}"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # Make use explicit
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOT

cat <<EOT >> "$HOME/.yarnrc.yml"
enableImmutableInstalls: true
enableScripts: false
enableTelemetry: false
EOT
if [ -n "$HTTP_PROXY" ]; then
  echo "httpProxy: $HTTP_PROXY" >> "$HOME/.yarnrc.yml"
fi
if [ -n "$HTTPS_PROXY" ]; then
  echo "httpsProxy: $HTTPS_PROXY" >> "$HOME/.yarnrc.yml"
fi
