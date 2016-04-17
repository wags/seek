#!/bin/bash

usage () {
    cat <<END
quick-search.sh [-s x] [-l x] [-t x] query

Find top repositories for a given query
    -s: sort by "star", "fork" or "date"
    -l: programming language name
    -t: authorization token (will ask to save it)
    -h: show this help screen
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

check_reqs ()
{
    for req in curl jq; do
        type $req >/dev/null 2>&1 || error "\"$req\" is required but it's not installed. Aborting." 1
    done
}

set_auth () {
    AUTH_STRING="Authorization: token $1"
}

set_vars () {
    set_auth "${GITHUB_ACCESS_TOKEN}"
    ENDPOINT="https://api.github.com/search/repositories"
    YELLOW=$(tput setaf 3)
    BRIGHT=$(tput bold)
    NORMAL=$(tput sgr0)
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

    # Get the result count and redirect the jq error to /dev/null:
    #    "jq: error (at <stdin>:2676): boolean (false) has no length"
    result_count=$(echo "$response_data" | jq ".[] | length" 2>/dev/null)

    # Generate an error and exit if there are no results
    [[ $result_count != 0 ]] || { echo "Sorry, no results found!"; exit 1; }

    limit=5
    if (( result_count < 5 )); then
        limit=$result_count
    fi

    for (( i=0; i<limit; ++i )); do
        name=$(echo "$response_data" | jq -r ".items[${i}].full_name")
        description=$(echo "$response_data" | jq -r ".items[${i}].description")
        stars=$(echo "$response_data" | jq -r ".items[${i}].stargazers_count")
        forks=$(echo "$response_data" | jq -r ".items[${i}].forks_count")
        date=$(echo "$response_data" | jq -r ".items[${i}].updated_at")

        printf "%s\n" "${BRIGHT}${name}${NORMAL}"
        printf "%s\n" "${description}"
        printf "${YELLOW}★ %-7s${NORMAL}" "${stars}"
        printf "Forks: %-7s" "${forks}"
        printf "Last Updated: %s\n\n" "${date}"
    done
}

while getopts ":s:l:t:h" opt; do
    case $opt in
        s)
            case ${OPTARG} in
                star|stars|s)
                    sort="stars";;
                fork|forks|f)
                    sort="forks";;
                date|updated|d|u)
                    sort="updated";;
                *)
                    error "Sort parameter \"${OPTARG}\" is invalid." 3;;
            esac
            ;;
        l)
            lang=${OPTARG}
            ;;
        t)
            set_auth "${OPTARG}"
            ;;
        h)
            usage
            exit 0
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
