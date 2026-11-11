# Основано на https://github.com/radleylewis/zsh (Radley Sidwell-Lewis, MIT).

mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
setopt AUTOCD NOBEEP NUMERIC_GLOB_SORT

if [[ -t 0 ]]; then
  export GPG_TTY="$(tty)"
fi

if (( $+commands[bat] )); then
  export MANPAGER="bat -l man -p"
elif (( $+commands[batcat] )); then
  export MANPAGER="batcat -l man -p"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

if (( $+commands[fzf] )); then
  source "$ZDOTDIR/fzf.zsh"

  # Выбираем одну установленную интеграцию fzf.
  for _fzf_dir in /usr/share/fzf /usr/share/doc/fzf/examples "$HOME/.fzf/shell"; do
    if [[ -r "$_fzf_dir/key-bindings.zsh" && -r "$_fzf_dir/completion.zsh" ]]; then
      source "$_fzf_dir/key-bindings.zsh"
      source "$_fzf_dir/completion.zsh"
      break
    fi
  done
  unset _fzf_dir
fi

source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/bindings.zsh"
source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/ssh-picker.zsh"

if [[ -r "$ZDOTDIR/local.zsh" ]]; then
  source "$ZDOTDIR/local.zsh"
fi
