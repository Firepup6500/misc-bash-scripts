#!/bin/env bash
printf "== !! == primary             == !! ==\n"
CLIP=$(xclip -selection primary -o)
printf $CLIP
[[ "$CLIP" == "12" ]] && printf "== !! == Trailing newline    == !! ==\n" || [[ "$CLIP" == "" ]] && printf "== !! == Clip is NULL        == !! ==\n" || printf "\n== !! == No trailing newline == !! ==\n"
printf "== !! == secondary           == !! ==\n"
CLIP=$(xclip -selection secondary -o)
printf $CLIP
[[ "$CLIP" == "12" ]] && printf "== !! == Trailing newline    == !! ==\n" || [[ "$CLIP" == "" ]] && printf "== !! == Clip is NULL        == !! ==\n" || printf "\n== !! == No trailing newline == !! ==\n"
printf "== !! == clipboard           == !! ==\n"
CLIP=$(xclip -selection clipboard -o)
printf $CLIP
[[ "$CLIP" == "12" ]] && printf "== !! == Trailing newline    == !! ==\n" || [[ "$CLIP" == "" ]] && printf "== !! == Clip is NULL        == !! ==\n" || printf "\n== !! == No trailing newline == !! ==\n"
printf "== !! == cut-buffer          == !! ==\n"
CLIP=$(xclip -selection cut-buffer -o)
printf $CLIP
[[ "$CLIP" == "12" ]] && printf "== !! == Trailing newline    == !! ==\n" || [[ "$CLIP" == "" ]] && printf "== !! == Clip is NULL        == !! ==\n" || printf "\n== !! == No trailing newline == !! ==\n"
