# Rust
if [ -f ~/.cargo/env ]; then
    . "$HOME/.cargo/env"
fi

# Node version manager
if [ `uname -m | grep arm64` ] && [ -d /opt/homebrew/opt/nvm ]; then
    # brew-installed nvm, macOS arm64
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
elif [ `uname -m | grep x86_64` ] && [ -d /usr/local/opt/nvm ]; then
    # brew-installed nvm, macOS x86_64
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
elif [ -d ~/.nvm ]; then
    # installed via official script
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Nix
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

# Homebrew
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Linuxbrew
if [ -f ~/.linuxbrew/bin/brew ]; then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
    # eval "$(/home/fredrik/.linuxbrew/bin/brew shellenv)"
    # eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Pyenv + auto venv activation on cd
if [ -d ~/.pyenv ]; then
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"

    function cd() {
    builtin cd "$@"

    if [[ -z "$VIRTUAL_ENV" ]] ; then
        ## If env folder is found then activate the vitualenv
        if [ -d ./.venv ] && [ -f ./venv/bin/activate ]; then
            source ./.venv/bin/activate
        fi
    else
        ## check the current folder belong to earlier VIRTUAL_ENV folder
        # if yes then do nothing
        # else deactivate
        parentdir="$(dirname "$VIRTUAL_ENV")"
        if [[ "$PWD"/ != "$parentdir"/* ]] ; then
            deactivate
        fi
    fi
    }
fi

if [ -n "${ZSH_VERSION}" ]; then
    # assume Zsh

    # Zsh autocompletion
    if [ -d ~/.zsh/zsh-autosuggestions ]; then
        source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi

    if [ -d ~/.zsh/zsh-syntax-highlighting ]; then
        source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi

    # Starship
    if command -v starship &> /dev/null; then
        eval "$(starship init zsh)"
    fi

elif [ -n "${BASH_VERSION}" ]; then
    # assume Bash

    # Bash autocompletion
    if [ -f /etc/profile.d/bash_completion.sh ]; then
        source /etc/profile.d/bash_completion.sh
    fi

    # Starship
    if command -v starship &> /dev/null; then
        eval "$(starship init bash)"
    fi
fi

