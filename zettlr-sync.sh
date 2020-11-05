#!/bin/bash

cd ~/zettlr
git add -A && git commit -m "autocommit"
git fetch && git rebase origin/master && git push origin HEAD:master
