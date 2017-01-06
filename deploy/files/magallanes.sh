#!/bin/bash

if [[ "ubuntu" == "$(whoami)" ]]; then
    cd "$HOME"

    composer global require --dev andres-montanez/magallanes:~1.0

    # add composer bin to PATH
    if ! grep -e '\/.composer\/vendor\/bin' .bashrc > /dev/null 2>&1; then
        echo 'PATH="$HOME/.composer/vendor/bin:$PATH"' >> "$HOME/.bashrc"
    fi
fi
