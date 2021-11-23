# docker-gcloud-cli

[![CircleCI](https://circleci.com/gh/aegirops/docker-gcloud-cli.svg?style=svg)](https://circleci.com/gh/aegirops/docker-gcloud-cli)

## Description

Docker with gcloud cli and kubectl for CI/CD purpose

This image is based on debian buster slim and contains:

- Gcloud sdk
- Python 3.7
- Kubectl
- Curl
- Git
- Docker cli
- Jq
- ytt 0.30
- postgresql-client-11
- nslookup
- s3cmd

This image is intended to be used in a gke CI/CD environment.

A second flavor is available containing also nodejs 14.
## DockerHub

Available publicly on:

- https://hub.docker.com/r/aegirops/gcloud-cli

