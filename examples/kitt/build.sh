#!/bin/bash

docker buildx build -t tribehealth/kitt-agent:v0.0.1 --push --platform=linux/amd64  .