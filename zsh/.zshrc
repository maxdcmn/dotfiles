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

setopt PROMPT_SUBST
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '(%b)'

precmd() {
  vcs_info
  local cur root repo rel
  cur=${PWD:A}
  root=$(git rev-parse --show-toplevel 2>/dev/null) || { PATH_SEG=$(print -P "%~"); BRANCH_SEG=""; return }
  root=${root:A}; repo=${root:t}
  PATH_SEG=$repo
  [[ $cur != "$root" ]] && { rel=${cur#"$root"/}; PATH_SEG="$repo/$rel"; }

  BRANCH_SEG="%F{187}${vcs_info_msg_0_}%f"
  local upstream counts behind
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null) || return
  counts=$(git rev-list --count --left-right "$upstream"...HEAD 2>/dev/null) || return
  behind=${counts%%$'\t'*}
  (( behind > 0 )) && BRANCH_SEG="%F{167}${vcs_info_msg_0_}%f"
}

PROMPT='%F{173}%n@%m%f %F{138}${PATH_SEG}%f${BRANCH_SEG} $ '

export VISUAL=nvim
export EDITOR=nvim
export RANGER_LOAD_DEFAULT_RC=FALSE
export FZF_DEFAULT_OPTS="--multi --no-height --extended"
export XDG_CONFIG_HOME="$HOME/.config"

source "$CONFIG_FOLDER/aliases.zsh"
