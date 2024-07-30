#!/bin/sh
path_to_headlines_json="src/headlines.json"
exec jq '.articles[] | (.publishedAt | fromdate | strftime("%B %d %Y %I:%M%p %Z")) as $foo | "\($foo): \(.title)"' "$path_to_headlines_json"
