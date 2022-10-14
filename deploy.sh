#!/usr/bin/env sh
set -e

yarn build

cd dist

git init
git remote add origin git@github.com:damianleguina/math-iv-euler.git
git branch -M main
git push -u origin main
git add -A
git commit -m 'deploy'

git push -f git@github.com:damianleguina/math-iv-euler.git main:gh-pages

cd -