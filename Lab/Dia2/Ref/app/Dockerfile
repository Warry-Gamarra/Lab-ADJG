FROM centos

RUN yum -y install openssh-server net-tools

RUN useradd devuser && echo "1234" | passwd devuser  --stdin && \
    mkdir /home/devuser/.ssh && \
    chmod 700 /home/devuser/.ssh

COPY llave.pub /home/devuser/.ssh/authorized_keys

RUN chown devuser:devuser  -R /home/devuser && \
    chmod 600 /home/remote_user/.ssh/authorized_keys

RUN /usr/sbin/sshd-keygen > /dev/null 2>&1

CMD /usr/sbin/sshd -D
