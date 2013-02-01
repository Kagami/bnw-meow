#!/bin/bash

COFFEE_DIR="coffee"
CCOFFEE_DIR="dist/static/js"

TEMPLATE_DIR="templates"
CTEMPLATE_DIR="dist/static/js/templates"

inotifywait -q -m -e modify --format="%w%f" -r "$COFFEE_DIR" "$TEMPLATE_DIR" |\
    while read file; do
        ext="${file##*.}"
        if [ "$ext" = "eco" ]; then
            tmp="`basename "$file"`"
            dest="$CTEMPLATE_DIR/${tmp/\.eco/.js}"
            echo "@@@ $file -> $dest"
            ./eco.js "$file" "$dest"
        elif [ "$ext" = "coffee" ]; then
            tmp="${file#*/}"
            subdir="`dirname "$tmp"`"
            dest="$CCOFFEE_DIR/${tmp/\.coffee/.js}"
            echo "@@@ $file -> $dest"
            coffee -o "$CCOFFEE_DIR/$subdir" -bc "$file"
        elif [ "$ext" = "gpp" ]; then
            make index
        fi
    done
