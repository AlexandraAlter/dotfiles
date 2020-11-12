# vim:fileencoding=utf-8:foldmethod=marker

# {{{ path
typeset -U PATH path
path=("$path[@]")
export PATH

if [[ -d "$HOME/bin" ]] {
  export PATH="$HOME/bin:${PATH}"
}

if [[ -d "$HOME/.local/bin" ]] {
  export PATH="$HOME/.local/bin:${PATH}"
}
# }}}

# {{{
export SUDO_ASKPASS="$HOME/bin/zenity-sudo.sh"
export GPG_TTY="$(tty)"
# }}}
