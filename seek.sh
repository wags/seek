#!/bin/bash

usage () {
    cat <<END
quick-search.sh [-s x] [-l x] [-t x] query

Find top repositories for a given query
    -s: sort by "stars", "forks" or "updated"
    -l: language
    -t: authorization token (will ask to save it)
END
}

set_vars () {
    AUTH_STRING="Authorization: token ${GITHUB_ACCESS_TOKEN}"
}

get_data () {
    URL="https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc"
    response_data=$(curl -s -H \
        "${AUTH_STRING}" "${URL}")
    echo $response_data | jq ".items[0,1,2,3,4] | {name, description, stargazers_count}"
}

set_vars
get_data

exit 0
