FROM equipindustry/python:3.8.0-slim

ARG stage
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

LABEL NAME zsh-functions-app-$stage

ENV PACKAGES bash \
        sudo \
        git \
        gcc \
        libc-dev \
        make \
        musl-dev \
        openssl \
        gcc \
        libgdal20 \
        libev-dev \
        curl \
        wget \
        tar \
        zsh \
        jq
ENV ZUNIT_VERSION "0.8.2"

COPY Pipfile* /usr/src/

# set working directory to /usr/src/
WORKDIR /usr/src/

RUN groupadd --gid ${USER_GID} ${USERNAME} \
# add user to docker group
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
# install packages
    && apt-get update -y \
    && apt-get install -y ${PACKAGES} --no-install-recommends \
# permissions
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \

    # revolver
    && curl -L https://raw.githubusercontent.com/molovo/revolver/master/revolver > /usr/local/bin/revolver \
    && chmod +x /usr/local/bin/revolver \
    # zunit
    && curl -L https://github.com/zunit-zsh/zunit/releases/download/v${ZUNIT_VERSION}/zunit > /usr/local/bin/zunit \
    && chmod +x /usr/local/bin/zunit \

    && mkdir -p /usr/src \
    && chown -R ${USERNAME} /usr/src \

    # pipenv
    && pip3 install pipenv \
    && pipenv install --dev --skip-lock \
    && pipenv shell --fancy \

    # clean
    && apt-get clean \
    && apt-get autoremove \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*
