#!/bin/bash
set -e
set -o pipefail

#tracking=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
head=$(git rev-parse HEAD)
upstream=$(git rev-parse @{u} 2>/dev/null || echo "${head}")
merge=$(git merge-base --octopus "${upstream}" "${head}")

if [[ "$1" != -- ]]; then
    list=true
else
    list=false
    merge=${head}
    shift
fi

echo "${head}"
echo "${merge}"
echo

"$@" | head -n 1
rustc --version
echo

if "${list}"; then
    git ls-files --others --exclude-standard | { grep -E '\.([ch]|[ch]pp|mk)$' || true; }
fi | {
    echo=false
    git diff --exit-code --irreversible-delete --ignore-submodules=dirty "${head}" -- || echo=true

    while IFS= read -r other; do
        echo=true
        git diff /dev/null "${other}" || true
    done

    if [[ ${merge} != ${head} ]]; then
        if "${echo}"; then echo; fi
        git show --format=fuller "${merge}".."${head}"
    fi
}
