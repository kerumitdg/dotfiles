#!/bin/bash -ex

# https://www.nerdfonts.com

# Per-platform settings
case $(uname) in
Darwin)
    # commands for macOS go here
    if ! ls "/Users/${USER}/Library/Fonts/Fira"* 1>/dev/null 2>&1; then
        curl --location --output ~/Downloads/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
        unzip -o ~/Downloads/FiraCode.zip -d ~/Downloads/FiraCode
        mkdir -p ~/Library/Fonts/
        cp -v ~/Downloads/FiraCode/*.otf ~/Library/Fonts/
        rm ~/Downloads/FiraCode.zip
        rm -r ~/Downloads/FiraCode
    fi
    ;;
Linux)
    # commands for Linux go here
    if ! ls ~/.local/share/fonts/Fira* 1>/dev/null 2>&1; then
        # Ubuntu
        curl --location --output ~/Downloads/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
        unzip -o ~/Downloads/FiraCode.zip -d ~/Downloads/FiraCode
        mkdir -p ~/.local/share/fonts
        sudo cp -v ~/Downloads/FiraCode/*.otf ~/.local/share/fonts
        rm ~/Downloads/FiraCode.zip
        rm -r ~/Downloads/FiraCode

    fi
    ;;
FreeBSD)
    # commands for FreeBSD go here
    ;;
MINGW64_NT-*)
    # commands for Git bash in Windows go here
    ;;
*) ;;
esac
