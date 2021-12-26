#!/bin/bash

if ! cmus-remote -C >/dev/null 2>&1 ; then
    exit 0
fi

info=$(cmus-remote -Q)

symbol="" #play symbol (old ▶)
state=$(echo "$info" | sed -n 's/^status //p')
if [ "$state" = "stopped" ] ; then
  symbol="" # stop symbol
  echo "$symbol"
  exit 0
elif [ "$state" = "paused" ] ; then
  symbol="" # pause symbol
fi

file=$(echo "$info" | sed -n 's/^file //p')
artist=$(echo "$info" | sed -n 's/^tag artist //p')
album=$(echo "$info" | sed -n 's/^tag album //p')
title=$(echo "$info" | sed -n 's/^tag title //p')

duration=$(echo "$info" | sed -n 's/^duration //p')
position=$(echo "$info" | sed -n 's/^position //p')
duration=`date -d@$duration -u +%M:%S`
position=`date -d@$position -u +%M:%S`

if [ -z "$title" ] ; then
    title=$(basename "$file" | sed 's/\.[A-Za-z0-9]*$//')
fi

if [ -n "$artist" -a -n "$album" ] ; then
    msg="$artist - $title"
elif [ -n "$artist" ] ; then
    msg="$artist - $title"
else
    msg="$title"
fi

echo "$symbol $msg [$position/$duration]"
