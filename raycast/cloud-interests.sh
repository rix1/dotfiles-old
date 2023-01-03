#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search Cloud Interests
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌤
# @raycast.packageName Otovo
# @raycast.argument1 { "type": "text", "placeholder": "status", "percentEncoded": true }
# @raycast.argument2 { "type": "text", "placeholder": "country", "percentEncoded": true }

open "http://staging-cloud.otovo.com/interest/?status=$1&country=$2"
