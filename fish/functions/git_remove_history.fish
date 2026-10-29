#!/bin/usr/env fish

# From stackoverflow.com/a/32886427
function git_remove_history
    echo "Remove $argv[1] from git history."
    git filter-branch --prune-empty --index-filter "git rm -rf --cached --ignore-unmatch $argv[1]" -- --all
    git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d
    rm -rf .git/logs .git/refs/original
    git gc --prune=all --aggressive
end

