#!/bin/bash
set -e

umask 0022

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
#  (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#   "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
function file_env() {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
    exit 1
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(< "${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

# envs=(
#   XYZ_API_TOKEN
# )
# haveConfig=
# for e in "${envs[@]}"; do
#   file_env "$e"
#   if [ -z "$haveConfig" ] && [ -n "${!e}" ]; then
#     haveConfig=1
#   fi
# done

# return true if specified directory is empty
function directory_empty() {
  [ -n "$(find "${1}"/ -prune -empty)" ]
}

function random_token() {
  tr -cd '[:alnum:]' </dev/urandom | fold -w32 | head -n1
}

# inspired by https://www.rfc-editor.org/rfc/rfc3986#appendix-B
# //URL prefix required. Not for IPv6 ([2001:db8::7]) addresses.
readonly URI_REGEX='^(([^:/?#]+):)?(//((([^:/?#]+)@)?([^:/?#]+)(:([0-9]+))?))?(/([^?#]*))?(\?([^#]*))?(#(.*))?'
protFromURL () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[2],,}"
}
hostFromURL () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[7],,}"
}
portFromURL () {
    if [[ "$@" =~ $URI_REGEX ]]; then
      if [[ -z "${BASH_REMATCH[9]}" ]]; then
        case "${BASH_REMATCH[2],,}" in
          # some default ports...
          http)  echo "80" ;;
          https) echo "443" ;;
          ldap)  echo "389" ;;
          ldaps) echo "636" ;;
        esac
      else
        echo "${BASH_REMATCH[9]}"
      fi
    fi
}

echo Running: "$@"

# Avoid destroying bootstrapping by simple start/stop
if [[ ! -e ${NODE_HOME}/.bootstrapped ]]; then
  ### list none idempotent code blocks, here...

  touch ${NODE_HOME}/.bootstrapped
fi

if [[ `basename ${1}` == "yarn" ]]; then # prod
    exec "$@" </dev/null #>/dev/null 2>&1
else # dev
    yarn start 2>&1 &
fi

# fallthrough...
exec "$@"
