ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ENV DEBIAN_FRONTEND noninteractive
ENV TF_VERSION 1.5.3
ENV pip_packages "ansible softlayer"

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        jq \
        python3-pip \
        python3-wheel \
        unzip \
        make \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

RUN pip install --upgrade pip \
    && pip install $pip_packages

RUN curl -O https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -f terraform_${TF_VERSION}_linux_amd64.zip \
    && chmod +x /usr/bin/terraform

USER vscode

RUN export BINDIR=/home/vscode/.local/bin && \
    curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# RUN curl -sS https://starship.rs/install.sh | sh
RUN curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir /home/vscode/.local/bin -f
COPY bashrc /home/vscode/.bashrc 
COPY starship.toml /home/vscode/.config/starship.toml

USER root
COPY post-start.sh /usr/local/bin/post-start
RUN chmod +x /usr/local/bin/post-start
