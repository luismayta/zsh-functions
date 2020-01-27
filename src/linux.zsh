#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# xclip::install - install xclip copy
function xclip::install {
    if ! type -p brew > /dev/null; then
        message_warning "${FUNCTIONS_MESSAGE_BREW}"
        return
    fi
    message_info "Install xclip"
    brew install xclip
    message_success "Installed xclip"
}

if ! type -p xclip > /dev/null; then xclip::install; fi

function open {
    if [ -e /usr/bin/xdg-open ]; then
        xdg-open "${1}"
    fi
}

function pbcopy {
    if type xclip > /dev/null; then
        xclip -selection clipboard
    fi
    if type xsel > /dev/null; then
        xsel --clipboard --input
    fi
}

function pbpaste {
    if type xclip > /dev/null; then
        xclip -selection clipboard -o
    fi
    if type xsel > /dev/null; then
        xsel --clipboard --output
    fi
}