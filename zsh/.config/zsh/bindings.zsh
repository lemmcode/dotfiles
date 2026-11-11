bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

if (( $+widgets[_fzf_file_no_hidden] )); then
  bindkey '^F' _fzf_file_no_hidden
fi

if (( $+widgets[autosuggest-toggle] )); then
  bindkey '^\' autosuggest-toggle
fi

if (( $+widgets[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi
