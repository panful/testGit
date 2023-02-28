#!/bin/bash

if [ -e ".git/hooks/pre-commit" ]; then
  echo "pre-commit exist,please check"
  exit
fi

cp "pre-commit" ".git/hooks/"
echo "pre-commit copied to .git/hooks"