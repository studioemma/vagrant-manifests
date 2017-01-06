#!/bin/bash

if [[ "ubuntu" == "$(whoami)" ]]; then
    cd "$HOME"
    ssh-keyscan -p7999 stash.studioemma.com >> "$HOME/.ssh/known_hosts"

    mkdir -p "$HOME/.bin/tools"
    cd "$HOME/.bin/tools"

    git clone ssh://git@stash.studioemma.com:7999/mag2/deploy.git

    cd "$HOME/.bin"
    ln -s tools/deploy/bin/deploy

    echo '#!/bin/bash' > "$HOME/.bin/deploy-self-update"
    echo '(' > "$HOME/.bin/deploy-self-update"
    echo 'cd $HOME/.bin/tools/deploy' >> "$HOME/.bin/deploy-self-update"
    echo 'git pull' >> "$HOME/.bin/deploy-self-update"
    echo ')' >> "$HOME/.bin/deploy-self-update"

    chmod +x "$HOME/.bin/deploy-self-update"
fi
