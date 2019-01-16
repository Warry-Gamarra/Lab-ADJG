# LABORATORIO 1 

### Administrando Docker

#### Docker Hola mundo!

```$docker run hello-world```


**Imagenes**

Buscar una imagen: ```$docker search image```
Descargar una imagen: ```$docker pull image```
Listar imagenes: ```$docker image```
Borrar imagen: ```$docker rmi $NAME```

**Contenedores**

Listar contendor: ```$docker ps -a```
Ejecutar un contenedor: ```$docker run -it --name superapi nginx```
Eliminar un contenedor: ```$docker rm -fv superapi```

**Actividad**

Buscar e instalar la imagen Nginx

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

## Jenkins Administracion

Como introducción,  vamos a trabajar con la imagen **jenkinsci**, para lo cual debemos descargarla de la siguiente forma:


```$docker pull jenkinsci/jenkins```

### OBS

- Por medio de Putty o cualquier cliente SSH en Windows, vamos a conectarnos a la VM que instaló Docker ToolBox ( VirtualBox ), user: docker / passwd: tcuser
- mkdir -p /opt/jenkins
- chmod 777 -R  /opt/jenkins

Con nuestro Dockerfile ya preparado, vamos a crear nuestro contenedor:

```$docker-compose up -d ( crea contenedor )
$docker-compose stop ( detener contenedor)
$docker-compose start ( inicar contenedor)
$docker-compose down ( eliminar contenedor )
```


Para validar el estado del contenedor usamos: *$docker ps -a*; ahora via el navegador vamos a ver lo sgt:

![web](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsweb.png "Web Jenkins")


### OBS
Para entrar al contenedor podemos usar: 

```$docker exec -it devjenkins bash```


### Administrando Jenkins

**Definiciones**
job o tareas: son optimizaciones de lo que deseemos realizar ( serie de pasos que hacen X cosas)
personas: usuarios permitidos
historial: cada tarea o job tiene un historico, todas las tareas de guardan.


**Creacion de Job:**

Nos ubiamos en: *Nueva Tarea/ mijob*

### OBS
Ojo Jenkins esta pensando en hacer tareas en servidores remotos.

opcion: bash
Guardar
Finalmente, construir ahora

Cuando hacemos clic en construir ahora, nos aparecerá  #1 que significa la primera ejecucion
hacemos clic en console output

Vamos a seguir mejorando nuestro job, para ello cli en modificar

echo "Hola Jenkins $(date)"  >> /tmp/log

Por ultimo, vamos a usar unas variables para nuestro job de la sgt manera:
NOMBRE="paquita"
echo "Hola $NOMBRE que estas haciendo?, ya es tarde? $(date +%F)" 

Vamos a manejar VARIABLES DE ENTORNO, para ello, vamos a crear un script de nombre jenkins.sh
#!/bin/bash
echo "hola $nombre $apellido"

Vamos a copiar jenkins.sh en el contenedor de jenkins:

$docker cp jenkins.sh devjenkins:/opt/

Entramos en el contenedor:
$docker exec -it devjenkins bash

Para enviar las variables adecuadas, entramos a nuestro job

Pues bien, vamos a ver el tema de PARAMETROS, para ello, vamos a crear un nuevo JOB de nombre: parameter
Y hacemos check en la opcion "esta ejecucion debe parametrizarse"

En añadir parametro, escogemos "parametro de cadena"

Agregamos un script de shell
echo "El $VALUE es un numero"

Hacemos clic en "build parameters"
