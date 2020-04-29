#!/bin/bash

set -eux

update_package_list() {
  sed -i -e 's/\(deb\|deb-src\) http:\/\/archive.ubuntu.com/\1 http:\/\/jp.archive.ubuntu.com/g' /etc/apt/sources.list
  apt update -y;
}

install_chrome() {
  curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
  apt-get update -y
  apt-get install -y google-chrome-stable
}

install_vim() {
  add-apt-repository -y ppa:jonathonf/vim
  apt-get update -y
  apt-get install -y vim
}

deploy_setting_files() {
  mv settings/keyboard /etc/default/keyboard
}

setup_remote_desktop() {
  apt-get install -y xrdp

  # 接続直後に"Authentication is required to create a color managed device"が表示される問題の対策
  echo "X-GNOME-Autostart-enabled=false" >> /etc/xdg/autostart/gnome-software-service.desktop
  echo "X-GNOME-Autostart-enabled=false" >> /etc/xdg/autostart/gnome-settings-daemon.desktop
}

setup_trivial() {
  # ビープ音無効化
  sed -i -r -e 's/#\s?set bell-style none/set bell-style none/' /etc/inputrc
  # visudoのエディタをvimに
  sudo update-alternatives --set editor /usr/bin/vim.basic
}

main() {
  apt-get purge -y libreoffice-* thunderbird*
  update_package_list

  # 先にopenssh-serverをinstallすると、特定バージョン依存の関係でエラーになるので先にopenssh-client削除
  apt-get purge -y openssh-client
  apt-get install -y openssh-server
  apt-get install -y software-properties-common
  apt-get install -y curl tree

  install_chrome
  install_vim

  setup_remote_desktop
  deploy_setting_files
  setup_trivial

  echo "dotfiles install end successfully."
  echo "ctrl-caps lock入れ替えを即時有効化する場合は再起動して下さい"
}

main
