FROM centos

RUN yum -y install openssh-server epel-release 

RUN useradd devuser &&  echo "devuser" | passwd devuser  --stdin 

RUN useradd jenkins &&  echo "abcd1234" | passwd jenkins  --stdin

RUN /usr/sbin/sshd-keygen > /dev/null 2>&1

RUN yum -y install python-pip mysql net-tools

RUN pip install --upgrade pip && pip install awscli

CMD /usr/sbin/sshd -D
