#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -e "${HOME}/.zsh-async/async.zsh" ] && source "${HOME}/.zsh-async/async.zsh"

# Define a function to process the result of the job
function functions::async::completed::callback {
    message_success "${@}"
}

function functions::async::init {
    if ! type async_init > /dev/null; then
        return
    fi
    async_init
    # Start a worker that will report job completion
    async_start_worker "${FUNCTIONS_ASYNC_NAME}" -u
    async_register_callback "${FUNCTIONS_ASYNC_NAME}" functions::async::completed::callback
}

functions::async::init