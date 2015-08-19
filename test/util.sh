#!/bin/sh

# from path/method to coffee:

cat test/swagger/pets-resolved.json | jq '.paths["/pets"].post' | json2cson

cat test/swagger/pets-resolved.json | jq '.paths["/pets"].post | {summary, parameters}' | json2cson

cat test/swagger/youtube-resolved.json | jq '.paths["/playlists"].post.parameters'

cat test/swagger/youtube-resolved.json | jq '.paths["/playlists"].post.parameters[] | {in, name, schema}'
