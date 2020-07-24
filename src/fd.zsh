#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Bool validate if have installed fd
#
function fd::validate::is_installed {
    if type -p fd > /dev/null; then
        echo 1
        return
    fi
    echo 0
}

function fd::install {
    if [ "$(fd::validate::is_installed)" -eq 1 ]; then
        return
    fi
    if ! type -p brew > /dev/null; then
        message_warning "please use antibody bundle luismayta/zsh-brew branch:develop"
        return
    fi
    brew install fd
}

fd::install