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
alias ff='fastfetch'
alias ports='lsof -i -P -n | grep LISTEN'
alias gl='git log --graph --pretty=format:"%C(yellow)%h%C(reset) %C(cyan)%ar%C(reset) %s %C(dim)— %an%C(reset)%C(auto)%d" --abbrev-commit -20'
fh() { history 1 | fzf | sed "s/ *[0-9]* *//" | $CLIP; }
roll() { echo $(( (RANDOM % (${1:-6})) + 1 )); }

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source "$CONFIG_FOLDER/book.zsh"
