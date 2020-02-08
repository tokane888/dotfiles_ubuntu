#!/bin/bash

set -eux

main() {
  apt purge -y libreoffice-* thunderbird*

  # 先にopenssh-serverをinstallすると、特定バージョン依存の関係でエラーになるので先にopenssh-client削除
  apt purge -y openssh-client
  apt install -y openssh-server
}

main
