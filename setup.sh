#!/usr/bin/bash
# Copyright 2023 HolyCorn Software
# This utility allows you to setup a debian server for nodejs hosting

if [[ $SKIP_DOWNLOAD != true ]]; then

    # Install gh
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt update
    sudo apt install gh

    # Install nvm
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

    SKIP_DOWNLOAD=true command_path=`readlink -f "${BASH_SOURCE:-$0}"`
    exit

fi

nvm install --lts

# Authenticate with git
gh auth login
gh auth setup-git

bash
