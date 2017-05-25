#!/usr/bin/env bash
set -x
echo "Downloading required archives"
./download_deps.sh
echo "Starting docker image"
docker-compose build