FROM centos

RUN yum -y install git && yum -y install java

VOLUME /tmp

ADD target microservice-0.0.1-SNAPSHOT.jar app.jar

RUN sh -c 'touch /app.jar'

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]


