# rm *で確認を求める機能を無効化
setopt RM_STAR_SILENT

# prompt表示にstarshipを使用するよう設定
eval "$(starship init zsh)"

# ctrl-]で指定gitのディレクトリへ移動
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# git: ctrl-x bでブランチ選択
function peco-branch () {
    local branch=$(git branch -a | peco | tr -d ' ' | tr -d '*')
    if [ -n "$branch" ]; then
      if [ -n "$LBUFFER" ]; then
        local new_left="${LBUFFER%\ } $branch"
      else
        local new_left="$branch"
      fi
      BUFFER=${new_left}${RBUFFER}
      CURSOR=${#new_left}
    fi
}
zle -N peco-branch
bindkey '^xb' peco-branch # C-x b でブランチ選択

eval "$(starship init zsh)"

. ~/.config/todoist_toggl.sh

## alias ===========================================

alias cdd="cd /home/tom/Downloads"
alias cdst="cd /home/tom/ghq/github.com/tokane888/manual/learn/statistics_basic"
alias xc="xclip -selection clipboard"
alias ffmpeg="ffmpeg -hide_banner"
alias s="sgpt"
alias sr="sgpt --repl program -s"
alias sc="sgpt --chat program -s"
alias ffplay="ffplay -hide_banner"
alias ffprobe="ffprobe -hide_banner"
alias tt="todoist list --filter today -p"
# todoistの今日のタスクからpecoで1つ選択し、詳細出力
alias td="todoist list --filter today -p | peco | cut -d' ' -f 1 | xargs -I % todoist show %"
