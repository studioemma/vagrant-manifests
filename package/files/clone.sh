#!/bin/bash

if [[ "vagrant" == "$(whoami)" ]]; then
    cd "$HOME"
    ssh-keyscan -p7999 stash.studioemma.com >> "$HOME/.ssh/known_hosts"

    # instal global package config
    echo 'globaltargetdir="/vagrant/packages"' > "$HOME/.package"

    mkdir -p "$HOME/.bin/tools"
    cd "$HOME/.bin/tools"

    git clone ssh://git@stash.studioemma.com:7999/mag2/package.git

    cd "$HOME/.bin"
    ln -s tools/package/bin/package

    echo '#!/bin/bash' > "$HOME/.bin/package-self-update"
    echo '(' > "$HOME/.bin/package-self-update"
    echo 'cd $HOME/.bin/tools/package' >> "$HOME/.bin/package-self-update"
    echo 'git pull' >> "$HOME/.bin/package-self-update"
    echo ')' >> "$HOME/.bin/package-self-update"

    chmod +x "$HOME/.bin/package-self-update"
fi
