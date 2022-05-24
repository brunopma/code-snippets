#!/bin/bash

# This script HTTP polls a host and notify me when the server responds with a desired code.
# Useful to wait for a slow http server to go up

# use it like: ./script.sh yourhost poll_period status_code
# e.g: ./script.sh google.com 1 200

HOST=$1
POLL_PERIOD=${2:-30} # Defaults to 30s
STATUS_CODE=${3:-200} # Defauts to 200 OK
MESSAGE="Host alive and responding with code ${STATUS_CODE}!"

# Be sure to have brew, and note that the notification only works in macOS
if [[ $OSTYPE != 'darwin'* ]]; then
  echo "this script only works in MacOS!!"
  exit 1
fi

# Install terminal-notifier
if test ! $(which terminal-notifier); then
    brew install terminal-notifier
fi

# The proper script

function notifyDone {
  terminal-notifier -title "Terminal" -message "$MESSAGE" -activate com.apple.Terminal;
}

while [[ $(curl -Ls -o /dev/null -w ''%{http_code}'' $HOST) != $STATUS_CODE ]]; do
echo "not yet! sleeping for $POLL_PERIOD seconds..."; sleep $POLL_PERIOD; done;
notifyDone;
