# docker-gcloud-cli

[![CircleCI](https://circleci.com/gh/aegirops/docker-gcloud-cli.svg?style=svg)](https://circleci.com/gh/aegirops/docker-gcloud-cli)

## Description

Docker with gcloud cli and kubectl for CI/CD purpose

This image is based on debian buster slim and contains:

- Gcloud sdk
- Gcloud sdk: gke-gcloud-auth-plugin
- Python 3.9.2
- Kubectl
- Curl
- Git
- Docker cli
- Docker compose cli
- Jq
- ytt v0.45.3
- postgresql-client-15
- nslookup
- s3cmd

This image is intended to be used in a gke CI/CD environment.

Other flavors are available containing nodejs 14, 16 or 18.

## DockerHub

Available publicly on:

- https://hub.docker.com/r/aegirops/gcloud-cli
