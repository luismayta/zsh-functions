#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function open {
    if [ -e /usr/bin/xdg-open ]; then
        xdg-open "${1}"
    fi
}

function pbcopy {
    if type -p xclip > /dev/null; then
        xclip -selection clipboard
    fi
    if type -p xsel > /dev/null; then
        xsel --clipboard --input
    fi
}

function pbpaste {
    if type -p xclip > /dev/null; then
        xclip -selection clipboard -o
    fi
    if type -p xsel > /dev/null; then
        xsel --clipboard --output
    fi
}