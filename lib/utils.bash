#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for volta.
GH_REPO="https://github.com/volta-cli/volta"
TOOL_NAME="volta"
TOOL_TEST="volta -v"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if volta is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_github_releases() {
  curl -fsSL https://api.github.com/repos/volta-cli/volta/releases | sed -nE 's/\s*"tag_name": "v([^"]+)",?/\1/p'
}

list_all_versions() {
  # Change this function if volta has other means of determining installable versions.
  list_github_releases || list_github_tags
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"

    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH/" "$install_path"
    if [[ ! -x "$install_path/bin/$tool_cmd" ]] && [[ -d "$install_path/$version" ]]; then
      echo "Fix cp command behavior" >&2
      # shellcheck disable=SC2115
      mv "$install_path/$version"/* "$install_path" && rm -fr "$install_path/$version"
    fi

    if [[ ! -x "$install_path/bin/$tool_cmd" ]]; then
      echo "ASDF_DOWNLOAD_PATH: $ASDF_DOWNLOAD_PATH"
      ls -lah "$ASDF_DOWNLOAD_PATH"
      echo "install_path: $install_path"
      ls -lah "$install_path"
      fail "Expected $install_path/bin/$tool_cmd to be executable."
    fi

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
#    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
