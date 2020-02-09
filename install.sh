#!/bin/bash

set -eux

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

main() {
  apt-get purge -y libreoffice-* thunderbird*

  # 先にopenssh-serverをinstallすると、特定バージョン依存の関係でエラーになるので先にopenssh-client削除
  apt-get purge -y openssh-client
  apt-get install -y openssh-server

  apt-get install -y software-properties-common
  apt-get install -y curl
  # TODO: ubuntu-software消したらアイコンが残った
  #       アイコン押下で起動するので何か残ってる
  install_chrome
  install_vim
}

main
