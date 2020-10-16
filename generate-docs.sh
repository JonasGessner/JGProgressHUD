#!/usr/bin/env sh

# Homebrew appledoc does not ship with templates...
git clone --depth 1 https://github.com/tomaz/appledoc

appledoc --output . --project-name JGProgressHUD --project-company "Jonas Gessner" --company-id "com.jonasgessner" --template appledoc/Templates --create-html --no-create-docset --no-install-docset JGProgressHUD/JGProgressHUD

rm -rf docs && mv html docs

rm -rf appledoc
