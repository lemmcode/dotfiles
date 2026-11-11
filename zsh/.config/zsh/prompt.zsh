if (( $+commands[starship] )); then
  export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
  export VIRTUAL_ENV_DISABLE_PROMPT=1
  FUNCNEST=100
  eval "$(starship init zsh)"
fi
