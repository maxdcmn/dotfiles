# ~/.config/zsh/aliases.zsh

mkcd () {
  mkdir -p -- "$1" && cd -P -- "$1"
}

alias v='nvim'
alias r='ranger'
alias g='lazygit'
alias d='docker'
alias k='kubectl'
alias f='cd $(fzf --walker=dir,follow,hidden --walker-skip=Library,Applications,.local,.cache,.git,miniconda3,node_modules,.vscode,.cargo)'
alias c='cd'
fh() { history 1 | fzf | sed "s/ *[0-9]* *//" | pbcopy; }
roll() { echo $(( (RANDOM % (${1:-6})) + 1 )); }
