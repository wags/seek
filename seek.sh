#!/bin/bash

usage () {
    cat <<END
quick-search.sh [-s x] [-l x] [-t x] query

Find top repositories for a given query
    -s: sort by "star", "fork" or "date"
    -l: programming language name
    -t: authorization token (will ask to save it)
END
}

# Function for custom error handling
# 1st argument: error message to print
# 2nd argument: exit code to exit script with
# Finally, redirect to stderr
error () {
    echo "Error: $1"
    usage
    exit "$2"
} >&2

check_reqs()
{
  for req in curl jq; do
    type $req >/dev/null 2>&1 || error "\"$req\" is required but it's not installed. Aborting." 1
  done
}

set_vars () {
    AUTH_STRING="Authorization: token ${GITHUB_ACCESS_TOKEN}"
    ENDPOINT="https://api.github.com/search/repositories"
}

get_data () {
    # https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc

    if [[ $lang ]]; then
        params="q=${params} language:${lang}"
    else
        params="q=${params}"
    fi

    response_data=$(curl -s -G "${ENDPOINT}" \
        --data-urlencode "${params}"         \
        --data-urlencode "sort=${sort}"      \
        --data-urlencode "order=desc"        \
        -H "${AUTH_STRING}"                  \
        )

    echo "$response_data" | jq ".items[0,1,2,3,4] | {name, description, stargazers_count, forks_count, updated_at}"
}

while getopts ":s:l:t:" opt; do
    case $opt in
        s)
            case ${OPTARG} in
                star)
                    sort="stars";;
                fork)
                    sort="forks";;
                date)
                    sort="updated";;
                *)
                    error "Sort parameter \"${OPTARG}\" is invalid." 3;;
            esac
            ;;
        l)
            lang=${OPTARG}
            ;;
        t)
            echo "-t detected with argument: ${OPTARG}"
            ;;
        :)
            error "Option -${OPTARG} is missing an argument" 2
            ;;
        \?)
            error "Unknown option: -${OPTARG}" 3
            ;;
    esac
done

# Gets the index of the next argument that getopts was going to handle,
# then uses that as the value to pass to shift.
shift $(( OPTIND -1 ))
[[ "$@" ]] || error "Oops, no search term was included!" 2

params="$*"

check_reqs
set_vars
get_data

exit 0
