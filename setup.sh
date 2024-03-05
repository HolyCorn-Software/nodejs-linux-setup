#!/usr/bin/bash
# Copyright 2023 HolyCorn Software
# This utility allows you to setup a debian server for nodejs hosting

NODE_VERSION=19

if [[ $SKIP_DOWNLOAD != true ]]; then

    # Install gh
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt update
    sudo apt install gh

    # Install nvm
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

    source ~/.bashrc
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


    # Install certbot
    sudo snap install certbot --classic

fi

nvm install $NODE_VERSION
nvm use $NODE_VERSION

# Authenticate with git
gh auth login
gh auth setup-git


# Now, make sure node, and nvm are globally available (/usr/bin/node, and /usr/bin/npm), and capable of binding to port 80

source ~/.bashrc

nodeCmds=("npm" "node")
for cmd in ${nodeCmds[@]}; do
    cmdBinPath=/usr/bin/$cmd
    if ! [ -f $cmdBinPath ]; then
        cmdPath=$(which $cmd)
        sudo rm -f $cmdBinPath
        sudo ln -s -r $cmdPath $cmdBinPath
        echo "Command $cmd linked to $cmdBinPath"
    fi

    # When dealing with node, let's allow it to bind to port 80
    if [ $cmd == "node" ]; then
        sudo setcap cap_net_bind_service='+ep' $cmdPath
        echo "Made $cmd capable of binding to port 80"
    fi
done
