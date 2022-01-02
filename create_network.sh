#!/bin/bash
# docker network
#LINES=$(docker network ls | grep dev | wc -l)
#if [ $LINES == '0' ]; then
#  docker network create dev
#fi

LINES=$(docker network ls | grep dev | wc -l)
if [ $LINES > '0' ]; then
  docker network remove dev
fi
docker network create --driver=bridge --subnet=172.30.0.0/24 dev
