# https://www.cherryservers.com/blog/ssh-into-docker-container
FROM ubuntu:22.04

ARG SSH_USERNAME
ENV SSH_USERNAME ${SSH_USERNAME}

# https://forums.docker.com/t/hash-sum-mismatch-writing-more-data-as-expected/45940/2
COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd

# Set root password for SSH access (change 'your_password' to your desired password)
RUN echo 'root:passw0rd!' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Add user "${SSH_USERNAME}"
RUN useradd -m -s /bin/bash ${SSH_USERNAME}

# Add the id_rsa.pub key to the new user's authorized_keys
RUN mkdir -p /home/${SSH_USERNAME}/.ssh && \
    chmod 700 /home/${SSH_USERNAME}/.ssh && \
    chown ${SSH_USERNAME}:${SSH_USERNAME} /home/${SSH_USERNAME}/.ssh

COPY ./id_rsa.pub /home/${SSH_USERNAME}/.ssh/authorized_keys
RUN chmod 600 /home/${SSH_USERNAME}/.ssh/authorized_keys && \
    chown ${SSH_USERNAME}:${SSH_USERNAME} /home/${SSH_USERNAME}/.ssh/authorized_keys

# Ensure the SSH daemon is enabled for the user
RUN echo "${SSH_USERNAME}:passw0rd!" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
