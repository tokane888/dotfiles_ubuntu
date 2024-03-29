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

  for repo in "${APT_REPOSITORIES[@]}"
  do
    add-apt-repository -y $repo
  done
  apt-get update -y
  apt-get install -y "${APT_PACKAGES[*]}"

  curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
  sudo apt-get update -y
  sudo apt-get install -y google-chrome-stable

  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_snap_packages() {
  snap refresh
  snap install "${SNAP_PACKAGES[*]}"
}

install_oh-my-zsh_plugin() {
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  ## TODO: .zshrcのpluginにgit zsh-syntax-highlighting zsh-autosuggestions追記
}

install_pip3_packages() {
  pip3 install "${PIP3_PACKAGES[*]}"
}

install_starship_shell_prompt() {
  pushd .
  ghq get https://github.com/ryanoasis/nerd-fonts.git
  cd "$(ghq list -p | grep nerd-fonts)"
  ./install.sh FiraCode
  popd

  curl -sS https://starship.rs/install.sh -o /tmp/starship_install.sh
  sh /tmp/starship_install.sh --yes

  mkdir ~/.config/
  cp config/startship.toml ~/.config/
}

install_todoist_toggl_cli() {
  ghq get https://github.com/urfave/cli.git
  ghq get https://github.com/sachaos/todoist.git

  ## TODO: todoist, togglのbuild, 設定周り追記
}

main() {
  setup_trivial
  install_deb_packages
  install_snap_packages
  install_pip3_packages
  install_starship_shell_prompt

  echo "dotfiles ubuntu script end successfully."
}

main
