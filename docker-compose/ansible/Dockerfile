FROM ubuntu:22.04

ARG ANSIBLE_CORE_VERSION
ARG ANSIBLE_VERSION
ARG ANSIBLE_LINT
ENV ANSIBLE_CORE_VERSION ${ANSIBLE_CORE_VERSION}
ENV ANSIBLE_VERSION ${ANSIBLE_VERSION}
ENV ANSIBLE_LINT ${ANSIBLE_LINT}

ENV DEBIAN_FRONTEND=noninteractive

# https://github.com/pypa/pip/issues/10219
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# https://forums.docker.com/t/hash-sum-mismatch-writing-more-data-as-expected/45940/2
COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y gnupg2 python3-pip sshpass git openssh-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN python3 -m pip install --upgrade pip cffi && \
    pip3 install ansible-core==${ANSIBLE_CORE_VERSION} && \
    pip3 install ansible==${ANSIBLE_VERSION} ansible-lint==${ANSIBLE_LINT} && \
    pip3 install mitogen jmespath && \
    pip install --upgrade pywinrm && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

RUN apt update && \
    apt install -y curl sudo lsb-core

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN sudo apt update && sudo apt install -y boundary

CMD [ "ansible-playbook", "--version" ]