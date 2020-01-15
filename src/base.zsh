#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# axel::install - install axel download manager
function axel::install {
    if ! type -p brew > /dev/null; then
        message_warning "${FUNCTIONS_MESSAGE_BREW}"
        return
    fi
    message_info "Install Axel"
    brew install axel
    message_success "Installed Axel"
}

# jq::install - install jq
function jq::install {
    if ! type -p brew > /dev/null; then
        message_warning "${FUNCTIONS_MESSAGE_BREW}"
        return
    fi
    message_info "Install JQ"
    brew install jq
    message_success "Installed JQ"
}

# ripgrep::install - install ripgrep
function ripgrep::install {
    if ! type -p brew > /dev/null; then
        message_warning "${FUNCTIONS_MESSAGE_BREW}"
        return
    fi
    message_info "Install ripgrep"
    brew install ripgrep
    message_success "Installed ripgrep"
}

# fzf::install - install fzf
function fzf::install {
    if ! type -p brew > /dev/null; then
        message_warning "${FUNCTIONS_MESSAGE_BREW}"
        return
    fi
    message_info "Install fzf"
    brew install fzf
    message_success "Installed fzf"
}

if ! type -p axel > /dev/null; then axel::install; fi
if ! type -p rg > /dev/null; then ripgrep::install; fi
if ! type -p fzf > /dev/null; then fzf::install; fi
if ! type -p jq > /dev/null; then jq::install; fi