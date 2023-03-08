FROM debian:bullseye-slim AS gcloud_cli

# Install curl and gnupg2
RUN apt-get update -y
RUN apt-get install -y \
    curl \
    gnupg2 \
    apt-transport-https \
    dnsutils

# Add the Cloud SDK distribution URI as a package source
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Add docker apt repository
RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable" >> /etc/apt/sources.list \
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
    docker-compose-plugin \
    google-cloud-sdk \
    google-cloud-sdk-gke-gcloud-auth-plugin \
    net-tools \
    python3 \
    python3-pip \
    python3-magic

# Install postgresql
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN sudo apt-get update -y
RUN sudo apt-get install postgresql-client-15 -y

# Add new user ci and set sudo without password
RUN adduser --disabled-password --gecos "" ci
RUN echo "ci     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install kubectl from google official source
RUN curl -o /usr/local/bin/kubectl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Install ytt yaml templating tool
RUN curl -o /usr/local/bin/ytt -LO https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.45.0/ytt-linux-amd64 \
    && chmod +x /usr/local/bin/ytt
# Install s3cmd
RUN pip3 install s3cmd

# Cleanup
RUN apt-get clean -y

# Use ci user and run bash
USER ci

CMD ["bash"]

FROM gcloud_cli AS gcloud_cli_nodejs_14

# Use root user
USER root

# Install node from linux binaries
RUN curl -o /tmp/node.tar.xz -LO https://nodejs.org/dist/v14.21.3/node-v14.21.3-linux-x64.tar.xz

RUN tar -xf /tmp/node.tar.xz -C /tmp

RUN cp -r /tmp/node-v14.21.3-linux-x64/lib/*  /lib/.

RUN cp -r /tmp/node-v14.21.3-linux-x64/bin/*  /bin/.

RUN rm -f /tmp/node.tar.xz

RUN node -v

FROM gcloud_cli AS gcloud_cli_nodejs_16

# Use root user
USER root

# Install node from linux binaries

RUN curl -o /tmp/node.tar.xz -LO https://nodejs.org/dist/v16.19.1/node-v16.19.1-linux-x64.tar.xz

RUN tar -xf /tmp/node.tar.xz -C /tmp

RUN cp -r /tmp/node-v16.19.1-linux-x64/lib/*  /lib/.

RUN cp -r /tmp/node-v16.19.1-linux-x64/bin/*  /bin/.

RUN rm -f /tmp/node.tar.xz

RUN node -v

FROM gcloud_cli AS gcloud_cli_nodejs_18

# Use root user
USER root

# Install node from linux binaries

RUN curl -o /tmp/node.tar.xz -LO https://nodejs.org/dist/v18.15.0/node-v18.15.0-linux-x64.tar.xz

RUN tar -xf /tmp/node.tar.xz -C /tmp

RUN cp -r /tmp/node-v18.15.0-linux-x64/lib/*  /lib/.

RUN cp -r /tmp/node-v18.15.0-linux-x64/bin/*  /bin/.

RUN rm -f /tmp/node.tar.xz

RUN node -v

