FROM --platform=linux/amd64 debian:bookworm-slim AS gcloud_cli

# Update
RUN apt-get update -y

# Install ca-certificates
RUN apt-get install -y ca-certificates

# Install utils
RUN apt-get install -y \
    curl \
    gnupg2 \
    apt-transport-https \
    dnsutils

# Add the Cloud SDK distribution URI as a package source
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Add docker apt repository
RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian bookworm stable" >> /etc/apt/sources.list \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Add helm repository
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" >> /etc/apt/sources.list \
    && curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y \
    sudo \
    curl \
    wget \
    git \
    gettext-base \
    jq \
    docker-compose-plugin \
    google-cloud-cli \
    google-cloud-cli-gke-gcloud-auth-plugin \
    net-tools \
    python3 \
    python3-pip \
    python3-magic \
    docker-ce-cli \
    docker-compose-plugin

# Install postgresql
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN sudo apt-get update -y
RUN sudo apt-get install postgresql-client-15 -y

# Add new user ci and set sudo without password
RUN adduser --disabled-password --gecos "" ci
RUN echo "ci     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install kubectl from google official source
RUN curl -o /usr/local/bin/kubectl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Install ytt yaml templating tool
RUN curl -o /usr/local/bin/ytt -LO https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.49.0/ytt-linux-amd64 \
    && chmod +x /usr/local/bin/ytt

# Install s3cmd
RUN rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED
RUN pip3 install s3cmd

# Cleanup
RUN apt-get clean -y

# Use ci user and run bash
USER ci

CMD ["bash"]

FROM gcloud_cli AS gcloud_cli_nodejs_18

# Use root user
USER root

# Install node from linux binaries
RUN curl -o /tmp/node.tar.xz -LO https://nodejs.org/dist/v18.20.2/node-v18.20.2-linux-x64.tar.xz

RUN tar -xf /tmp/node.tar.xz -C /tmp

RUN cp -r /tmp/node-v18.20.2-linux-x64/lib/*  /lib/.

RUN cp -r /tmp/node-v18.20.2-linux-x64/bin/*  /bin/.

RUN rm -f /tmp/node.tar.xz

RUN node -v

FROM gcloud_cli AS gcloud_cli_nodejs_20

# Use root user
USER root

# Install node from linux binaries
RUN curl -o /tmp/node.tar.xz -LO https://nodejs.org/dist/v20.12.2/node-v20.12.2-linux-x64.tar.xz

RUN tar -xf /tmp/node.tar.xz -C /tmp

RUN cp -r /tmp/node-v20.12.2-linux-x64/lib/*  /lib/.

RUN cp -r /tmp/node-v20.12.2-linux-x64/bin/*  /bin/.

RUN rm -f /tmp/node.tar.xz

RUN node -v

