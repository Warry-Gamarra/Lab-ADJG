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
- Ejecutar un contenedor: ```$docker run -it --name superapi nginx```
- Eliminar un contenedor: ```$docker rm -fv superapi```

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


### Consola Jenkins

**Definiciones**

- job o tareas: son optimizaciones de lo que deseemos realizar ( serie de pasos que hacen X cosas)
- personas: usuarios permitidos
- historial: cada tarea o job tiene un historico, todas las tareas de guardan.

![consola](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsc.png "Consola Jenkins")


**Creacion de Job:**

Nos ubicamos en: *Nueva Tarea/ myjob*

![Job](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmyjob.png "Job")


### OBS
Ojo Jenkins esta pensando en hacer tareas en servidores remotos.


Luego de dar OK!, veremos esta pantalla: 

![ex](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsex.png "ex")


Nos deslizamos hasta la opción **EJECUTAR**
- opcion: Linea de Comandos Shell
- Guardar
- Finalmente, construir ahora

![ex2](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsex2.png "ex2")


Para ejecutar nuestro **JOB** simplemente hacemos clic en **"construir ahora"**

### OBS
Cuando hacemos clic en construir ahora, nos aparecerá  **#1** que significa la primera ejecución
hacemos **clic** en ***console output***

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild.png "build")

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild1.png "build")


Vamos a seguir mejorando nuestro job, para ello hacemos clic en **configurar**
Agregamos lo siguiente en el campo **"Ejecutar"**


```echo "Hola Jenkins $(date)"  >> /tmp/log```

Ejecutamos nuestro job, hacemos clic en **"construir ahora"**

**OBS**
Esto se va a ejecutar en el contenedor de Jenkins ojo!


![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkins2.png "build")

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkins3.png "build")


Por último, vamos a usar unas variables para nuestro job de la sgt manera:

**Actividad**

Modificar el job con lo sgt y ejecutarlo:

```
NOMBRE="paquita"
echo "Hola $NOMBRE que estas haciendo?, ya es tarde? $(date +%F)" 
```

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild4.png "build")



Vamos a manejar **VARIABLES DE ENTORNO**, para ello, vamos a crear un script de nombre **jenkins.sh** para ejeuctarlo via el job.


```
#!/bin/bash
echo "hola $nombre $apellido"
```

A jenkins.sh damos permisos de ejecución: ***chmod +x jenkins.sh***

Vamos a copiar **jenkins.sh** en el contenedor de jenkins:

```$docker cp jenkins.sh devjenkins:/opt/```

Entramos en el contenedor:

```$docker exec -it devjenkins bash```


Si ejecutamos el job veremos este resultado:

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild5.png "build")
![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild6.png "build")

Vemos que no se estan invocando las variables ... ¿?

Esto se debe a que las variables de entorno son volatiles, nombre y apellido son variables que no son reconocidas por el script.

Vamos a pasarlo como parametros de esta forma:

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild7.png "build")
![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild8.png "build")


Vemos que sigue sin funcionar, debido a que el script no sabe interpretar de forma correcta los parametros que le hemos asignado, por ello, vamos a modificar
el script de la sgt forma:

```
#!/bin/bash
nombre=$1
apellido=$2
echo "hola $nombre $apellido"
```


Copiamos el script nuevamente al contendor, volvemos a "construir ahora"  y validamos el resultado

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild9.png "build")


### OBS
De esta forma de interactuan con scripts fuera de nuestro contenedor.



Pues bien, ahora vamos a enviarle los PARAMETROS adecuados, para ello, vamos a crear un nuevo JOB de nombre: **parameter**
Y hacemos check en la opcion "esta ejecucion debe parametrizarse"


![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild10.png "build")


En añadir parametro, escogemos "parametro de cadena"
- Nombre: VALUE
- Valor por defecto: 20

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild11.png "build")


Nos ubicamos en **EJECUTAR**

Agregamos un script de shell ( Ejecutar linea de comandos shell )

```echo "El $VALUE es un numero"```

Hacemos clic en "build parameters"


![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild12.png "build")
![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild13.png "build")





