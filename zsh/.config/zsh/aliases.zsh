if (( $+commands[eza] )); then
  alias ls='eza --icons=auto'
  alias ll='eza -lh --icons=auto --git'
  alias la='eza -lah --icons=auto --git'
  alias tree='eza --tree --icons=auto'
  compdef eza=ls
else
  alias ll='ls -lh'
  alias la='ls -lah'
fi

alias diff='diff --color=auto'
alias df='df -h'
alias -- -='cd -'

# Возвращаем shell в выбранный каталог только после успешного выхода lf.
if (( $+commands[lf] )); then
  lf() {
    local tmp dir lf_status
    tmp=$(mktemp) || return
    command lf -last-dir-path="$tmp" "$@"
    lf_status=$?
    dir=$(<"$tmp")
    rm -f -- "$tmp"
    (( lf_status == 0 )) || return "$lf_status"
    if [[ -d "$dir" && "$dir" != "$PWD" ]]; then
      builtin cd -- "$dir" || return
    fi
  }
fi

if (( $+commands[micro] )); then
  alias m='micro'
fi
