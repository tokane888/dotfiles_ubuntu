#!/bin/bash
. config.sh

set -euxo pipefail

setup_trivial() {
  # visudoのエディタをvimに
  sudo update-alternatives --set editor /usr/bin/vim.basic
}

install_deb_packages() {
  # localhost:5600でdashboardが見られるが、OS再起動するまでは見えない
  curl -LO https://github.com/ActivityWatch/activitywatch/releases/download/v0.12.2/activitywatch-v0.12.2-linux-x86_64.deb
  dpkg -i activitywatch-v0.12.2-linux-x86_64.deb

  add-apt-repository -y ppa:hluk/copyq
  apt-get update -y
  apt-get install -y ${APT_PACKAGES[*]}

  curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
  sudo apt-get update -y
  sudo apt-get install -y google-chrome-stable

  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_snap_packages() {
  snap refresh
  snap install ${SNAP_PACKAGES[*]}
}

install_oh-my-zsh_plugin() {
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  ## TODO: .zshrcのpluginにgit zsh-syntax-highlighting zsh-autosuggestions追記
}

main() {
  setup_trivial
  install_deb_packages
  install_snap_packages

  echo "dotfiles ubuntu script end successfully."
}

main
