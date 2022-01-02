#!/usr/bin/env bash
if [ $# != 2 ]; then
    echo Please public_key name: $*
    echo Please deploy dir name: $*
    exit 1
else
  echo $HOME/.ssh/$1 to ./Docker/$2/$1
  cp $HOME/.ssh/$1 ./Docker/$2/$1
fi
