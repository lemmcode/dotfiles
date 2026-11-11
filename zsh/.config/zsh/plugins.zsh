ZPLUGINDIR="$XDG_DATA_HOME/zsh/plugins"

_zplugin_load() {
  local plugin_path="$ZPLUGINDIR/$2"
  if [[ ! -d "$plugin_path" ]]; then
    if (( ! $+commands[git] )); then
      print -u2 "ERROR: git is required to install $2"
      return 1
    fi
    mkdir -p "$ZPLUGINDIR" || return
    print -r -- "Installing $2..."
    git clone --depth=1 "https://github.com/$1/$2" "$plugin_path" \
      || { print -u2 "ERROR: failed to install $2"; return 1; }
  fi
  if [[ ! -r "$plugin_path/$2.plugin.zsh" ]]; then
    print -u2 "ERROR: missing plugin entry point for $2"
    return 1
  fi
  source "$plugin_path/$2.plugin.zsh"
}

zplugin-update() {
  local dir failed=0
  for dir in "$ZPLUGINDIR"/*/(N); do
    print -r -- "Updating ${dir:t}..."
    git -C "$dir" pull --ff-only || failed=1
  done
  return "$failed"
}

_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zsh-users zsh-history-substring-search
_zplugin_load zdharma-continuum fast-syntax-highlighting
