# ~/.zshrc

[[ $- != *i* ]] && return
bindkey -v

CONFIG_FOLDER="$HOME/.config/zsh"

os=$(uname -s)
if [[ $os == "Darwin" ]]; then
  STAT_CMD="stat -L -f %m "
else
  STAT_CMD="stat -L -c %Z "
fi

export PS1="%F{green}%n@%m%f: %F{red}%~%f "
export VISUAL=nvim
export EDITOR=nvim
export RANGER_LOAD_DEFAULT_RC=FALSE
export FZF_DEFAULT_OPTS="--multi --no-height --extended"
export XDG_CONFIG_HOME="$HOME/.config"

source "$CONFIG_FOLDER/aliases.zsh"
