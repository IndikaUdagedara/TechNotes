#!/usr/bin/env -S bash

git add .
git commit -am "Auto-sync $(date +"%Y-%m-%d %H:%M:%S")"
git push