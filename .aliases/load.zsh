eval "$(atuin init zsh --disable-up-arrow)"
eval "$(zoxide init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

source <(kubie generate-completion)
source <(carapace _carapace)

