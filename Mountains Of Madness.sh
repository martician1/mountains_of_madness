#!/bin/sh
printf '\033c\033]0;%s\a' Mountains Of Madness
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Mountains Of Madness.x86_64" "$@"
