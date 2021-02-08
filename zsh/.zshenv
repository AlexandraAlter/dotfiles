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

if [[ -d "$HOME/.cargo/bin" ]] {
  export PATH="$HOME/.cargo/bin:${PATH}"
}
# }}}

# {{{ gpg
export SUDO_ASKPASS="$HOME/bin/zenity-sudo.sh"
export GPG_TTY="$(tty)"
# }}}

# {{{ ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
# }}}
