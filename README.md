# Seek
A speedy command-line search tool for repositories on GitHub

## What is this?
Seek is a Bash script that allows you to search for repositories on GitHub from your command line. The top 10 results are displayed for the given keyword(s), along with the number of stars, forks, and the date it was last updated.

## Usage and Tweaks
_(basic usage first)_

While the default search results can be helpful, you have the power to adjust the results! :zap:

_(advanced usage)_

## Prerequisites
* `curl`: (This _should_ be installed on your computer already, but the script will double-check for it just in case)
* `jq`: Used to parse the JSON response from the API. The easiest way to install it on a Mac is with Homebrew. Just run `brew install jq`. Otherwise, follow the guide [here](https://stedolan.github.io/jq/download).
* A GitHub access token. This is optional, but providing one will allow you to search much more frequently before rate limiting kicks in. It's super easy [to generate one](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)!

## Why did you build this?
## Motivation
I was drawn to the GitHub search API endpoint because of my love of Elasticsearch, Solr and software built with these technologies. Many tasks can be performed quickly with the command line, but the commands to interact with an API can get unwieldy to piece together. This script makes it simple to work with various parameters and authentication, and gets you the results you're looking for quickly.

Is there already a popular repo with the name you're thinking about using? Did someone else already come up with a solution to a challenge that you're facing? Which user or organization owns that new project you heard about? Get the answers to these and other questions you might have with the help of Seek! 🔍
