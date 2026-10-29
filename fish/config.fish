if test "$TERM" = linux
    set -gx LANG C
end

fish_add_path "$HOME/.config/fish/scripts"

alias gdb           "gdb -nh -x $XDG_CONFIG_HOME/gdb/init"
alias gdb-multiarch "gdb-multiarch -nh -x $XDG_CONFIG_HOME/gdb/init"
alias tmux          "tmux -2 -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias xsel          "xsel -l $XDG_CACHE_HOME/xsel/xsel.log"
