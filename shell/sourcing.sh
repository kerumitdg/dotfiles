# shellcheck shell=bash
# shellcheck source=/dev/null

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

# Nix
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

# Pyenv + auto venv activation on cd
if [ -d ~/.pyenv ]; then
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"

    function cd() {
        builtin cd "$@" || return

        if [[ -z "$VIRTUAL_ENV" ]]; then
            ## If env folder is found then activate the vitualenv
            if [ -d ./.venv ] && [ -f ./venv/bin/activate ]; then
                source ./.venv/bin/activate
            fi
        else
            ## check the current folder belong to earlier VIRTUAL_ENV folder
            # if yes then do nothing
            # else deactivate
            parentdir="$(dirname "$VIRTUAL_ENV")"
            if [[ "$PWD"/ != "$parentdir"/* ]]; then
                deactivate
            fi
        fi
    }
fi

# NVM
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    . "/opt/homebrew/opt/nvm/nvm.sh"
fi

# Rust
if [ -f ~/.cargo/env ]; then
    . "$HOME/.cargo/env"
fi

if [ -n "${ZSH_VERSION}" ]; then
    # assume Zsh

    # auto-load .nvmrc file
    autoload -U add-zsh-hook
    load-nvmrc() {
        local node_version="$(nvm version)"
        local nvmrc_path="$(nvm_find_nvmrc)"

        if [ -n "$nvmrc_path" ]; then
            local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

            if [ "$nvmrc_node_version" = "N/A" ]; then
                nvm install
            elif [ "$nvmrc_node_version" != "$node_version" ]; then
                nvm use
            fi
        elif [ "$node_version" != "$(nvm version default)" ]; then
            echo "Reverting to nvm default version"
            nvm use default
        fi
    }
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc

    # Zsh autocompletion
    if [ -d ~/.zsh/zsh-autosuggestions ]; then
        source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi

    if [ -d ~/.zsh/zsh-syntax-highlighting ]; then
        source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi

    # mcfly
    if [ -f /opt/homebrew/bin/mcfly ] || [ -f /usr/local/bin/mcfly ]; then
        eval "$(mcfly init zsh)"
    fi

    # Starship
    if command -v starship &>/dev/null; then
        eval "$(starship init zsh)"
    fi

elif [ -n "${BASH_VERSION}" ]; then
    # assume Bash

    # NVM bash completion
    if [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]; then
        # macOS, installed via homebrew
        . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    elif [ -s "$HOME/.nvm/bash_completion" ]; then
        # linux, installed via official script
        . "$HOME/.nvm/bash_completion"
    fi

    # Bash autocompletion
    if [ -f /etc/profile.d/bash_completion.sh ]; then
        source /etc/profile.d/bash_completion.sh
    fi

    # mcfly
    if [ -f /opt/homebrew/bin/mcfly ] || [ -f /usr/local/bin/mcfly ]; then
        eval "$(mcfly init bash)"
    fi

    # Starship
    if command -v starship &>/dev/null; then
        eval "$(starship init bash)"
    fi
fi
