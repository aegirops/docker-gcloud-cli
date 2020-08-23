FROM debian:stretch-slim

# Install curl and gnupg2
RUN apt-get update -y
RUN apt-get install -y \
    curl \
    gnupg2 \
    apt-transport-https \
    dnsutils

# Add the Cloud SDK distribution URI as a package source
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Add docker apt repository
RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" >> /etc/apt/sources.list \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y \
    sudo \
    curl \
    wget \
    git \
    gettext-base \
    jq \
    docker-ce-cli \
    google-cloud-sdk \
    net-tools

# Install postgresql
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN sudo apt-get update -y
RUN sudo apt-get install postgresql-client-11 -y

# Add new user ci and set sudo without password
RUN adduser --disabled-password --gecos "" ci
RUN echo "ci     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install kubectl from google official source
RUN curl -o /usr/local/bin/kubectl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Install ytt yaml templating tool
RUN wget --quiet -O- https://k14s.io/install.sh | bash

# Cleanup
RUN apt-get clean -y

# Use ci user and run bash
USER ci

CMD ["bash"]
