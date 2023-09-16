# dotfiles ubuntu

デスクトップとして使用する想定のubuntu実機向けdotfilesの暫定置き場。  
サーバとして使用する想定のubuntuについては[dotfiles](https://github.com/tokane888/dotfiles)で対応

## 使用方法

- sudo su -
- ./install.sh

### 必要に応じて下記実施

- .zshrc配置
- todoist cliインストール
  - https://github.com/sachaos/todoist#install
- toggl cliインストール
  - https://github.com/AuHau/toggl-cli
  - OS起動時のtodoist sync自動実行有効化
    - todoist-syncディレクトリ配下を/lib/systemd/system/に配置
    - systemctl daemon-reload
    - systemctl enable --now todoist-sync.service
- ディスプレイ + カメラ映像録画service登録
  - cd pc_usage_record.service /lib/systemd/system/
  - systemctl daemon-reload
  - systemctl enable --now pc_usage_record.service