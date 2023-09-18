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

# 追加ツール関連設定 ===========================================

## todoist CLI + toggl CLI連携し、ctrl+x => t => sでtodoistの今日の指定タスクをtogglで計測開始
function toggl-start-todoist () {
    local selected_item_id=`todoist list --filter today -p | peco | cut -d ' ' -f 1`
    if [ ! -n "$selected_item_id" ]; then
        return 0
    fi
    local selected_item_content=`todoist --csv show ${selected_item_id} | grep Content | cut -d',' -f2- | sed s/\"//g`
    local selected_item_project=`todoist --csv show ${selected_item_id} | grep Project | cut -d',' -f2- | sed 's/^#//'`
    if [ -n "$selected_item_content" ]; then
        BUFFER="toggl start \"${selected_item_content}\" --project \"${selected_item_project}\""
        CURSOR=$#BUFFER
        zle accept-line
    fi
}
zle -N toggl-start-todoist
bindkey '^xts' toggl-start-todoist

# todoist find project
function peco-todoist-project () {
    local SELECTED_PROJECT="$(todoist projects | peco | head -n1 | cut -d ' ' -f 1)"
    if [ -n "$SELECTED_PROJECT" ]; then
        if [ -n "$LBUFFER" ]; then
            local new_left="${LBUFFER%\ } $SELECTED_PROJECT"
        else
            local new_left="$SELECTED_PROJECT"
        fi
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
}
zle -N peco-todoist-project
bindkey "^xtp" peco-todoist-project

# todoist find labels
function peco-todoist-labels () {
    local SELECTED_LABELS="$(todoist labels | peco | cut -d ' ' -f 1 | tr '\n' ',' | sed -e 's/,$//')"
    if [ -n "$SELECTED_LABELS" ]; then
        if [ -n "$LBUFFER" ]; then
            local new_left="${LBUFFER%\ } $SELECTED_LABELS"
        else
            local new_left="$SELECTED_LABELS"
        fi
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
}
zle -N peco-todoist-labels
bindkey "^xtl" peco-todoist-labels

# todoist find project
function peco-todoist-project () {
    local SELECTED_PROJECT="$(todoist projects | peco | head -n1 | cut -d ' ' -f 1)"
    if [ -n "$SELECTED_PROJECT" ]; then
        if [ -n "$LBUFFER" ]; then
            local new_left="${LBUFFER%\ } $SELECTED_PROJECT"
        else
            local new_left="$SELECTED_PROJECT"
        fi
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
}
zle -N peco-todoist-project
bindkey "^xtp" peco-todoist-project

# todoist find labels
function peco-todoist-labels () {
    local SELECTED_LABELS="$(todoist labels | peco | cut -d ' ' -f 1 | tr '\n' ',' | sed -e 's/,$//')"
    if [ -n "$SELECTED_LABELS" ]; then
        if [ -n "$LBUFFER" ]; then
            local new_left="${LBUFFER%\ } $SELECTED_LABELS"
        else
            local new_left="$SELECTED_LABELS"
        fi
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
}
zle -N peco-todoist-labels
bindkey "^xtl" peco-todoist-labels

# todoist close
function peco-todoist-close() {
    local SELECTED_ITEMS="$(todoist list | peco | cut -d ' ' -f 1 | tr '\n' ' ')"
    if [ -n "$SELECTED_ITEMS" ]; then
        BUFFER="todoist close $(echo "$SELECTED_ITEMS" | tr '\n' ' ')"
        CURSOR=$#BUFFER
    fi
    zle accept-line
}
zle -N peco-todoist-close
bindkey "^xtc" peco-todoist-close

PROG=todoist source "/home/tom/ghq/github.com/urfave/cli/autocomplete/zsh_autocomplete"

eval "$(starship init zsh)"

## alias ===========================================

alias cdd="cd /home/tom/Downloads"
alias cdst="cd /home/tom/ghq/github.com/tokane888/manual/learn/statistics_basic"
alias xc="xclip -selection clipboard"
alias tt="taskwarrior-tui"
alias ffmpeg="ffmpeg -hide_banner"
alias s="sgpt"
alias sr="sgpt --repl program -s"
alias sc="sgpt --chat program -s"
alias ffplay="ffplay -hide_banner"
alias ffprobe="ffprobe -hide_banner"
alias tt="todoist list --filter today -p"
# todoistの今日のタスクからpecoで1つ選択し、詳細出力
alias td="todoist list --filter today -p | peco | cut -d' ' -f 1 | xargs -I % todoist show %"
