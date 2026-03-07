#!/bin/bash
echo "== !! == primary             == !! =="
CLIP=$(xclip -selection primary -o)
echo -n $CLIP
[[ "$CLIP" == "12" ]]&&echo "== !! == Trailing newline    == !! =="||[[ "$CLIP" == "" ]]&&echo "== !! == Clip is NULL        == !! =="||echo -e "\n== !! == No trailing newline == !! =="
echo "== !! == secondary           == !! =="
CLIP=$(xclip -selection secondary -o)
echo -n $CLIP
[[ "$CLIP" == "12" ]]&&echo "== !! == Trailing newline    == !! =="||[[ "$CLIP" == "" ]]&&echo "== !! == Clip is NULL        == !! =="||echo -e "\n== !! == No trailing newline == !! =="
echo "== !! == clipboard           == !! =="
CLIP=$(xclip -selection clipboard -o)
echo -n $CLIP
[[ "$CLIP" == "12" ]]&&echo "== !! == Trailing newline    == !! =="||[[ "$CLIP" == "" ]]&&echo "== !! == Clip is NULL        == !! =="||echo -e "\n== !! == No trailing newline == !! =="
echo "== !! == cut-buffer          == !! =="
CLIP=$(xclip -selection cut-buffer -o)
echo -n $CLIP
[[ "$CLIP" == "12" ]]&&echo "== !! == Trailing newline    == !! =="||[[ "$CLIP" == "" ]]&&echo "== !! == Clip is NULL        == !! =="||echo -e "\n== !! == No trailing newline == !! =="
