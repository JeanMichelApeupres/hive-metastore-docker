#!/usr/bin/env bash

set -euf -o pipefail

docker build -t hive-metastore:4.0.1 --build-arg HIVE_VERSION="4.0.1" --build-arg HADOOP_VERSION="3.3.6" .

docker compose up -d