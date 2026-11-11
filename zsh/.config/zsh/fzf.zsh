if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
elif (( $+commands[fdfind] )); then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --strip-cwd-prefix'
else
  export FZF_DEFAULT_COMMAND='find . -type f'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'

if (( $+commands[bat] )); then
  export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 -- {}'
elif (( $+commands[batcat] )); then
  export _FZF_PREVIEW_CMD='batcat --color=always --style=plain,numbers --line-range=:500 -- {}'
else
  export _FZF_PREVIEW_CMD='head -n 500 -- {}'
fi
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  if [[ "$cmd" == 'find . -type f' ]]; then
    cmd+=" -not -path '*/.*'"
  fi
  if result=$(eval "$cmd" | fzf --no-multi --preview "$_FZF_PREVIEW_CMD") && [[ -n "$result" ]]; then
    LBUFFER+="${(q)result} "
  fi
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
