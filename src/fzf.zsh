#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# fo [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fo {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "${files}" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fgb [FUZZY PATTERN] - Checkout specified branch
# Include remote branches, sorted by most recent commit and limited to 30
function fgb {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "${branches}" |
            fzf-tmux -d $(( 2 + $(wc -l <<< "${branches}") )) +m) &&
    git checkout $(echo "${branch}" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# ftm [SESSION_NAME | FUZZY PATTERN] - create new tmux session, or switch to existing one.
# Running `tm` will let you fuzzy-find a session mame
# Passing an argument to `ftm` will switch to that session if it exists or create it otherwise
function ftm {
    [[ -n "${TMUX}" ]] && change="switch-client" || change="attach-session"
    if [ "${1}" ]; then
    tmux "${change}" -t "${1}" 2>/dev/null \
        || (tmux new-session -d -s "${1}" && tmux "${change}" -t "${1}"); return
    fi

    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) && tmux ${change} -t "${session}" || echo "No sessions found."
}

# ftmk [SESSION_NAME | FUZZY PATTERN] - delete tmux session
# Running `tm` will let you fuzzy-find a session mame to delete
# Passing an argument to `ftm` will delete that session if it exists
function ftmk {
    if [ "${1}" ]; then
    tmux kill-session -t "${1}"; return
    fi
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null \
        | fzf --exit-0) &&  tmux kill-session -t "${session}" || echo "No session found to delete."
}

# fgr fuzzy grep via rg and open in vim with line number
function fgr {
    local file
    local line

    read -r file line <<<"$(rg --no-heading --line-number $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

    if [ -n "${file}" ]; then
        vim "+${line}" "${file}"
    fi
}