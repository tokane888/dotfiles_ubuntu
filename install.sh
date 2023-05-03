#!/bin/bash

set -eux

setup_trivial() {
  # visudoのエディタをvimに
  sudo update-alternatives --set editor /usr/bin/vim.basic
}

main() {
  setup_trivial

  echo "dotfiles ubuntu script end successfully."
}

main
