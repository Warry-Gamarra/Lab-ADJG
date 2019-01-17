# LABORATORIO 1 

### Administrando Docker

#### Docker Hola mundo!

```$docker run hello-world```


**Imagenes**

- Buscar una imagen: ```$docker search image```
- Descargar una imagen: ```$docker pull image```
- Listar imagenes: ```$docker image```
- Borrar imagen: ```$docker rmi $NAME```

**Contenedores**

- Listar contendor: ```$docker ps -a```
- Ejecutar un contenedor: 


```$docker run -it --name superapi nginx bash```


```$docker run -d --name superapi -p 80:80 nginx```


- Eliminar un contenedor: ```$docker rm -fv superapi```

**Actividad**

Buscar e instalar la imagen Apache con el TAG NAME = sapache y el puerto 80 debe visualizarse por el puerto 8282 en 
el HOST.

**Dockerfile**

Un Dockerfile es un archivo de texto plano que contiene las instrucciones necesarias para automatizar la creación de una imagen que será utilizada posteriormente para la ejecución de instancias específicas ( i.e. contenedores ).

Ejm.
```
FROM centos:7

RUN yum -y install httpd

CMD apachectl -DFOREGROUND
```


Para ejecutar un Dockerfile, usamos: ```$docker build --tag apache-build .  ```

Con esto configuramos nuestra imagen de Centos7 con apache ( httpd ), ahora la ejecutamos: ```$docker run -d -p 80:80 apache-build ```

Vamos a agregar un index.html en nuestra imagen para ello, en nuestro Dockerfile

```
FROM centos

RUN yum -y install httpd

WORKDIR /var/www/html

COPY index.html .

ENV contenido prueba web 

RUN echo "$contenido" > /var/www/html/prueba.html                                                                                                                     

CMD apachectl -DFOREGROUND
```

Lo ejecutamos: ```$docker build -t apache-new . ```

**Actividad**
Instalar la imagen de Tomcat que inicie en el puerto 8080 del HOST 


Para crear un volumen para un contenedor: 

```$docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=123456" -v /opt/mysql:/var/lib/mysql mysql:5.7```

Si queremos crear una RED:
```$docker network create lab-net```

```docker network create **-d** bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1 lab-net```

Asignando la red a un contenedor
```$docker run -d --network lab-net --name dev2 -ti centos```

## Vagrant

## Ansible

## Git/GitHub

## Caso Practico:
- Desplegar una infraestructura con 2 Nodos, 1 vm con ansible 
- Ejecutar un playbook con: instalacion 1vm con mysql + usuario dba + carpeta /opt/deploy
- Subir una imagen a DockerHub
- Subir Dockerfile y docker-compose a Github
