_ssh_config_hosts() {
  local file
  local -a files
  for file in "$HOME"/.ssh/config(N) "$HOME"/.ssh/conf.d/*.conf(N); do
    [[ -f "$file" && -r "$file" ]] && files+=("$file")
  done
  (( ${#files} )) || return 0

  # shortcut: читаем простые Host из config и conf.d/*.conf; расширить при других Include.
  awk '
    { sub(/#.*/, ""); sub(/^[[:blank:]]*[Hh][Oo][Ss][Tt][[:blank:]]*=[[:blank:]]*/, "Host ") }
    tolower($1) == "host" {
      for (i = 2; i <= NF; i++)
        if ($i !~ /[*?!]/ && $i !~ /^-/) print $i
    }
  ' "${files[@]}" | sort -u
}

zstyle -e ':completion:*:(ssh|scp|sftp|rsync|slogin):*' hosts \
  'reply=( ${(f)"$(_ssh_config_hosts)"} )'

if (( $+commands[fzf] && $+commands[ssh] )); then
  _ssh_pick_host() {
    _ssh_config_hosts | fzf --no-multi --prompt='ssh ❯ ' --height=40% --layout=reverse --border \
      --preview 'ssh -G -- {} | grep -iE "^(hostname|user|port|identityfile|proxycommand|proxyjump) "' \
      --preview-window=right:45%
  }

  sshp() {
    local host
    host=$(_ssh_pick_host) || return
    [[ -n "$host" ]] && command ssh -- "$host"
  }

  sshp_widget() {
    zle -I
    local host
    if host=$(_ssh_pick_host) && [[ -n "$host" ]]; then
      BUFFER="ssh -- ${(q)host}"
      zle accept-line
    else
      zle reset-prompt
    fi
  }

  zle -N sshp_widget
  bindkey '^P' sshp_widget
fi
