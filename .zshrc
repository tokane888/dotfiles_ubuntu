# rm *で確認を求める機能を無効化
setopt RM_STAR_SILENT

# prompt表示にstarshipを使用するよう設定
eval "$(starship init zsh)"

# 追加ツール関連設定 ===========================================

## todoist CLI + toggl CLI連携し、ctrl+x => t => sでtodoistのタスクをtogglで計測開始
function toggl-start-todoist () {
    local selected_item_id=`todoist --project-namespace --namespace list | peco | cut -d ' ' -f 1`
    if [ ! -n "$selected_item_id" ]; then
        return 0
    fi
    local selected_item_content=`todoist --csv show ${selected_item_id} | grep Content | cut -d',' -f2- | sed s/\"//g`
    if [ -n "$selected_item_content" ]; then
        BUFFER="toggl start \"${selected_item_content}\""
        CURSOR=$#BUFFER
        zle accept-line
    fi
}
zle -N toggl-start-todoist
bindkey '^xts' toggl-start-todoist
