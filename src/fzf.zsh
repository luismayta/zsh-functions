#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# fkill [FUZZY PATTERN] - List process the selected process for kill
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fkill {
    # Kill process
    local pid
    pid="$(ps -ef | sed 1d | fzf -m | awk '{print $2}')"

    if [ "x${pid}" != "x" ]
    then
        echo ${pid} | xargs kill -${1:-9}
    fi
}

# fa [FUZZY PATTERN] - Open the path to open
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fa {
    # fa <dir> - Search dirs and cd to them - TODO: ignore node_modules + other things
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
    cd "${dir}"
}

# fah [FUZZY PATTERN] - Open the files hidden
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fah {
    # fah <dir> - Search dirs and cd to them (included hidden dirs)
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "${dir}"
}

# fcs [FUZZY PATTERN] - Search commits hash
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fcs {
    local commits commit
    commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) && \
    commit=$(echo "${commits}" | fzf --tac +s +m -e --ansi --reverse) && \
    echo -n $(echo "${commit}" | sed "s/ .*//")
}

# fenv [FUZZY PATTERN] - Open the selected var env value
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fenv {
    # Search env variables
    local out
    out=$(env | fzf)
    echo $(echo -n ${out} | cut -d= -f2 | ghead -c -1 | pbcopy)
}

# falias [FUZZY PATTERN] - Search alias with fzf
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function falias {
    # Search alias by key or values
    local out
    out=$(alias | fzf)
    echo $(echo -n ${out} | cut -d= -f2 | ghead -c -1 | pbcopy)
}


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