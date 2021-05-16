#!/usr/bin/env bash

# set -x
set -euo pipefail

function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

function app_exists() {
  local name="id of app \"$@\""
  osascript -e "$name" >/dev/null 2>&1
}

function hasStr() {
  grep -sq $1 $2
}

if ! app_exists 'hammerspoon'; then
  if ! command_exists 'brew'; then
    echo "Homebrew is required: https://brew.sh/" && exit 1
  fi
  brew install hammerspoon
fi

folder="config"

mkdir -p "$HOME/.hammerspoon"

ln -sfn $PWD "$HOME/.hammerspoon"

# require="require('${folder}')"

# if ! hasStr $require ~/.hammerspoon/init.lua; then
#   echo "$require -- Load Hammerspoon bits from https://github.com/TaumuLu/hammerspoon-config" >> ~/.hammerspoon/init.lua
# fi

killall Hammerspoon || true

open /Applications/Hammerspoon.app

osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Hammerspoon.app", hidden:true}' > /dev/null

echo "🎉🎉🎉 install hammerspoon config success!"

