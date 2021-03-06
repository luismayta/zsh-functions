#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines functions for osx or linux.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#
#
FUNCTIONS_PLUGIN_DIR="$(dirname "${0}")"
FUNCTIONS_SOURCE_PATH="${FUNCTIONS_PLUGIN_DIR}"/src

export FUNCTIONS_MESSAGE_BREW="Please install brew or use antibody bundle luismayta/zsh-brew branch:develop"

export PATH="${FUNCTIONS_PLUGIN_DIR}/bin:${PATH}"

# shellcheck source=/dev/null
source "${FUNCTIONS_SOURCE_PATH}"/async.zsh

# shellcheck source=/dev/null
source "${FUNCTIONS_SOURCE_PATH}"/base.zsh

# shellcheck source=/dev/null
source "${FUNCTIONS_SOURCE_PATH}"/utils.zsh

# copy pub key to buffer
function pubkey {
    more "${HOME}"/.ssh/id_rsa.pub | perl -pe 'chomp'  | pbcopy && message_info '====> Public key copied to pasteboard.'
}

# cross::os functions for osx and linux
function cross::os {

    case "${OSTYPE}" in
        darwin*)
            # shellcheck source=/dev/null
            source "${FUNCTIONS_SOURCE_PATH}"/darwin.zsh
            ;;
        linux*)
            # shellcheck source=/dev/null
            source "${FUNCTIONS_SOURCE_PATH}"/linux.zsh
            ;;
    esac

}

# download - Implement axel to settings chunk 20
function download {
    if ! type -p axel > /dev/null; then axel::install; fi
    local filename
    filename="${1}"
    axel -n 20 -av "${filename}"
}

if type -p fd > /dev/null; then
    # Setting fd as the default source for fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    # Apply the command to CTRL-T as well
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

# ip - show ip of internet
function ip {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# localip - show ip of internet
function localip {
    ipconfig getifaddr en0
}

if type -p fzf > /dev/null; then
    # shellcheck source=/dev/null
    source "${FUNCTIONS_SOURCE_PATH}"/fzf.zsh
fi

if type -p ag > /dev/null; then
    # shellcheck source=/dev/null
    source "${FUNCTIONS_SOURCE_PATH}"/ag.zsh
fi

# shellcheck source=/dev/null
source "${FUNCTIONS_SOURCE_PATH}"/fd.zsh

cross::os
