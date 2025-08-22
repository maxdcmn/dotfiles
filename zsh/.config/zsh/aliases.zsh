# ~/.config/zsh/aliases.zsh

mkcd () {
  mkdir -p -- "$1" && cd -P -- "$1"
}

alias v='nvim'
alias r='ranger'
alias g='lazygit'
alias go='cd $(fzf --walker=dir,follow,hidden --walker-skip=Library,Applications,.local,.cache,.git,miniconda3,node_modules,.vscode,.cargo)'
alias c='cd'
