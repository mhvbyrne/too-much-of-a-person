#!/bin/bash

# Enable error reporting to the console.
set -e

# Install bundles if needed.
bundle check || bundle install

# NPM install if needed.
. $HOME/.nvm/nvm.sh && nvm install 6.1 && nvm use 6.1
npm install

# Build the site.
gulp

# Checkout master and remove everything
git clone https://github.com/DeckOfPandas/too-much-of-a-person.git ../too-much-of-a-person.master
cd ../too-much-of-a-person.master
git checkout master
rm -rf *

# Copy generated HTML site from source branch in original repo.
# Now the master branch will contain only the contents of the _site directory.
cp -R ../too-much-of-a-person/_site/* .

# Make sure we have the updated .travis.yml file so tests won't run on master.
cp ../too-much-of-a-person/.travis.yml .
git config user.email ${GH_EMAIL}
git config user.name "tmoap-bot"

# Commit and push generated content to `master` branch.
git status
git add -A .
git status
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin `master` > /dev/null 2>&1