#! /bin/bash

docker run --rm "$(docker build -q .)"
