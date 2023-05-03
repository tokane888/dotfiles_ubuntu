#!/bin/bash

set -eux

setup_trivial() {
  # visudoのエディタをvimに
  sudo update-alternatives --set editor /usr/bin/vim.basic
}

install_packages() {
  # localhost:5600でdashboardが見られるが、OS再起動するまでは見えない
  curl -LO https://github.com/ActivityWatch/activitywatch/releases/download/v0.12.2/activitywatch-v0.12.2-linux-x86_64.deb
  dpkg -i activitywatch-v0.12.2-linux-x86_64.deb
}

main() {
  setup_trivial
  install_packages

  echo "dotfiles ubuntu script end successfully."
}

main
