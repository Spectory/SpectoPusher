#!/bin/bash

# Deploys Coyote server to Heroku.
#
# Heroku project setup:
# 1. Follow https://hexdocs.pm/phoenix/heroku.html.
# 2. Make sure you set needed ENV vars. Searching the logs for `EnvHelper`
#    errors may help.
#

GREEN='\033[1;32m'
NC='\033[0m' # No Color
if [ "$1" != "" ]; then
  repo=$1
else
  printf "${GREEN}missing repo name...${NC}\n"
  exit
fi

# split subtree into heroku-deploy temp branch
printf "${GREEN}Preparing deploy branch...${NC}\n"
git subtree split --prefix server -b heroku-deploy

# Push server folder (from master branch) to Heroku.
printf "${GREEN}Deploying to $repo...${NC}\n"
git push -f $repo heroku-deploy:master

# Delete temp branch
printf "${GREEN}Cleaning up...${NC}\n"
git branch -D heroku-deploy
