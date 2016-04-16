# Seek
A speedy command-line tool for searching repositories on GitHub

[![Build Status](https://travis-ci.org/wags/seek.svg?branch=master)](https://travis-ci.org/wags/seek)

<a href="https://octodex.github.com"><img align="right" hspace="10" height="220" src="https://octodex.github.com/images/inspectocat.jpg"></a>


## What is this?
Seek is a Bash script that allows you to search for repositories on GitHub from your command line. The top 5 results are displayed for the given keyword(s), along with the number of stars, forks, and the date it was last updated. Put Inspectocat* to work!

## Prerequisites
* `curl`: (This _should_ be installed on your computer already, but the script will double-check for it just in case)
* `jq`: Used to parse the JSON response from the API. The easiest way to install it on a Mac is with [Homebrew](http://brew.sh/). Just run `brew install jq`. Otherwise, follow the guide [here](https://stedolan.github.io/jq/download).
* A GitHub access token. This is optional, but providing one will allow you to search much more frequently before rate limiting kicks in. It's super easy [to generate one](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)!

To save your GitHub token to an environment variable for this script to access, use the following command.
```
export GITHUB_ACCESS_TOKEN=your-secret-token
```
Otherwise, you will have to pass it every time (cumbersome) due to the fact that a script cannot set a value in its parent's environment. 

## Usage
First, make sure the script has execute permissions:
```
chmod u+x seek.sh
```

Then, for a basic search, just pass the term you'd like to search for:
```
./seek.sh tetris
```

While the default search results are great, the full power is unleashed when you use these advanced options to adjust the results! :zap:

| Option | Description |
| :----: | :---------- |
| `-s x` | **sort**: Tell Seek how you'd like to sort the results. Valid options for _x_ are `star`, `fork`, and `date` (descending)
| `-l x` | **language**: Specify _x_ programming language name to limit results to that language |
| `-t x` | **token**: Pass your private GitHub access token (_x_) to Seek in order to increase the API rate limit. |

Here's a more elaborate example to try:
```
./seek.sh -s star -l assembly tetris
```

_Now get out there and get searching!_

## Motivation
I was drawn to the GitHub search API endpoint because of my love of Elasticsearch, Solr and software built with these technologies. Many tasks can be performed quickly with the command line, but the commands to interact with an API can get unwieldy to piece together. This script makes it simple to work with various parameters and authentication, and gets you the results you're looking for quickly.

Is there already a popular repo with the name you're thinking about using? Did someone else already come up with a solution to a challenge that you're facing? Which user or organization owns that new project you heard about? Get the answers to these and other questions you might have with the help of Seek! :mag_right:

### Credit
\* _Image is "the Inspectocat" by [Jason Costello](https://github.com/jasoncostello) from the [GitHub Octodex](https://octodex.github.com/inspectocat) and included for fun only!_
