export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
if [[ -r "$ZDOTDIR/.zshenv" ]]; then
  source "$ZDOTDIR/.zshenv"
fi
