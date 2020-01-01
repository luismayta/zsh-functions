#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines functions for osx or linux.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#
#
ZSH_FUNCTIONS_PLUGIN_D=$(dirname "$0")
export PATH="${ZSH_FUNCTIONS_PLUGIN_D}/bin:${PATH}"

# cross::os functions for osx and linux
function cross::os {

    case "${OSTYPE}" in
    linux*)
        if type -p xclip > /dev/null; then
            alias pbcopy="xclip -selection clipboard"
            alias pbpaste="xclip -selection clipboard -o"
        fi

        if type -p xsel > /dev/null; then
            alias pbcopy="xsel --clipboard --input"
            alias pbpaste="xsel --clipboard --output"
        fi

        if [ -e /usr/bin/xdg-open ]; then
            alias open="xdg-open"
        fi
      ;;
    esac

}

# axel::install - install axel download mananger
function axel::install {
    if type -p brew > /dev/null; then
        message_info "Install Axel"
        brew install axel
    fi
}

# download - Implement axel to settings chunk 20
function download {
    if ! type -p axel > /dev/null; then axel::install; fi
    local filename
    filename="${1}"
    axel -n 20 -av "${filename}"
}

# ripgrep::install - install ripgrep
function ripgrep::install {
    if type -p brew > /dev/null; then
        brew install ripgrep
    fi
}

# fzf::install - install fzf
function fzf::install {
    if type -p brew > /dev/null; then
        brew install fzf
    fi
}

if ! type -p axel > /dev/null; then axel::install; fi
if ! type -p rg > /dev/null; then ripgrep::install; fi
if ! type -p fzf > /dev/null; then fzf::install; fi


if type -p rg > /dev/null; then
    # Setting rg as the default source for fzf
    export FZF_DEFAULT_COMMAND='rg --files'

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
fi

cross::os
