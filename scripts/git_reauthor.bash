#!/usr/bin/env bash

function reauthor_all {
    if [[ "$#" -eq 0  ]]; then
        echo "Incorrect usage, no email given, usage is: $FUNCNAME <email>" 1>&2
        return 1
    fi

    local old_email="$1"

    # Based on
    # SO: https://stackoverflow.com/a/34863275/9238801

    local new_email="$(git config --get user.email)"
    local new_name="$(git config --get user.name)"

    # get each commit's email address ( https://stackoverflow.com/a/58635589/9238801  )
    # I've broken this up into two statements and concatenated
    # because I want to delay evaluation

    local command='[[ "$(git log -1 --pretty=format:'%ae')" =='
      command+=" '$old_email' ]] && git commit --amend --author '$new_name <$new_email>' --no-edit || true"


    git rebase -i --root -x "$command"
}
