# LABORATORIO 2

## Jenkins Administracion

Como introducción,  vamos a trabajar con la imagen **jenkinsci**, para lo cual debemos descargarla de la siguiente forma:


```$docker pull jenkinsci/jenkins```

### OBS

- Por medio de Putty o cualquier cliente SSH en Windows, vamos a conectarnos a la VM que instaló Docker ToolBox ( VirtualBox ), user: docker / passwd: tcuser
- mkdir -p /home/docker/jenkins
- chmod 1000  /home/docker/jenkins

Con nuestro docker-compose.yml, vamos a crear nuestro contenedor de jenkins:


```version: '3'
services:
  jenkins:
    container_name: devjenkins
    image: jenkinsci/jenkins
    ports:
      - "8080:8080"
    volumes:
      - $PWD/jenkins:/var/jenkins_home
    networks:
      - net
networks:
  net:
```


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

Tenemos mas tipos de parametros en Jenkins que nos pueden ser de utilidad, por lo cual vamos a ver lo siguiente:

- En nuestro job "parameter" vamos a agregar la opción **Elección**

Con los campos a completar: 
- Nombre: ***OPCION*** 
- Opciones: ***SI, NO, Ninguno***


![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild14.png "build")


Nos ubicamos en la parte del script y añadimos: **$OPCION**

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild15.png "build")

Tendremos esta pantalla

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild16.png "build")


Ejecutamos nuestro job


![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild17.png "build")

Vamos a añadir ahora un "valor boleano" TRUE/FALSE sobre nuestro job **parameter**

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild18.png "build")


### OBS
Si hacemos check, el valor por defecto es **TRUE**


En nuestro script, añadimos la variable:

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild19.png "build")


Ejecutamos nuestro job y debemos tener lo siguiente:

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild20.png "build")

Y en la ejecución:

![build](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsbuild21.png "build")


### Jenkins hacia un Contendor 


Todo nuestro trabajo ha sido realizado en el contendor de Jenkins, lo que es valido para ciertos trabajos, pero en un caso "real" necesitamos  conectarnos a un host/contenedor remoto y ejecutar jobs, para ello, vamos a crear previamente un contenedor, para trabajar con el y los jobs que despleguemos:

Nos conectamos a nuestro servidor Docker y en la ruta: /home/docker, vamos a crear la carpeta **app** ( dentro la carpeta app crearemos nuestro archivo Dockerfile )

Con nuestra carpeta creada, vamos a rehusar nuestro archivo: docker-compose.yml, el cual será el que cree nuestra imagen y enviandole las instrucciones necesarias a nuestro archivo Dockerfile.


**docker-compose.yml**


```version: '3'
services:
  jenkins:
    container_name: devjenkins
    image: jenkinsci/jenkins
    ports:
      - "8080:8080"
    volumes:
      - /home/docker/jenkins:/var/jenkins_home
    networks:
      - net
  remote_host:
    container_name: appremoto
    image: imgapp
    build:
      context: app 
    networks:
      - net
networks:
  net:
```

Lo que hará docker-compose, es crear un contenedor con imagen centos, esta imagen tendra de nombre **imgapp** y el nombre del contenedor será: **appremoto**.


Dentro de la carpeta app, el contenido de nuestro Dockerfile será:


```FROM centos

RUN yum -y install openssh-server net-tools

RUN useradd devuser && \
    echo "devuser" | passwd devuser  --stdin && mkdir /home/devuser/.ssh && \
    chmod 700 /home/devuser/.ssh

COPY llave.pub /home/devuser/.ssh/authorized_keys

RUN chown devuser:devuser  -R /home/devuser &&  chmod 600 /home/devuser/.ssh/authorized_keys

RUN /usr/sbin/sshd-keygen > /dev/null 2>&1

CMD /usr/sbin/sshd -D
```

### TIP
Este ejemplo se basa en crear llaves SSH para el contenedor, en nuestro ejm. no lo usaremos.

Para finalizar, creamos las llaves SSH para la conexion:

**```ssh-keygen -f llave```**


Ahora, nos ubicamos en **/home/docker**, y ejecutamos **docker-compose build && docker-compose up -d**

Acto siguiente desde la consola, vamos a activar el plugin de SSH y realizar la configuracion del contenedor que hemos creado.

En el menú de Jenkins: 

**Administrar Jenkins / Administrar plugins**


Acontinuación vamos a crear las credenciales para nuestro contendor, para ello hacemos clic en **credentials**

![credentials](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinscredentials.png "credentials")


![credentials](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinscredentials1.png "credentials")


Bien, ahora vamos a agregar las credenciales

![credentials](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsuser.png "credentials")


Al finalizar, debemos tener esta pantalla

![credentials](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsuser1.png "credentials")


Bien, Con el plugin activado y la credencial creada, vamos a configurar nuestro contenedor para que Jenkins pueda conectarse a el.

**Administrar Jenkins / Configurar el Sistema**

Vamos a buscar la opción: **SSH remote hosts**

![ssh](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsssh.png "ssh")

Ingresamos estos datos: 
- HOSTNAME del contenedor, puedes ser la IP
- Puerto: 22 

![valida](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsvalida.png "valida")


Hacemos clic en el boton **Check Connection** y el resultado debe ser "Successfull conection"

Para guardar la configuracion, nos posicionamos en la ultima parte del menu, y damos clic en "guardar"

Hasta ahora, ya tenemos todo listo para ejecutar/lanzar nuestro primer **JOB** en nuestro contenedor, para ello, vamos a crear una tarea / job:

- Nombre Tarea: **valida-tarea**
- Crear proyecto de libre estilo

Nos ubicamos en la opcion: **Ejecutar** y escogemos **Ejecutar shell script on remote host using ssh** 


![ssh](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsjobssh.png "ssh")


Vamos a crear un pequeño mensaje y guardarlo en /tmp/log.txt en el contenedor centos.


![ssh](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsjobssh1.png "ssh")


Pues bien, vamos a ejecutar nuestro job, hacemos clic en **construir ahora**

Y validamos nuestro job:


![ssh](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsjobf.png "ssh")


### OBS


- Recordar que devuser debe tener permisos de RWX si desea escribir/modificar/ejcutar el contenido en un directorio donde no sea el owner.
- Para validar nuestro JOB en el contenedor:  **docker exec -it devapp bash**


### Jenkins con AWS

Objetivo:

- vamos a crear un job, el cual se ocnecte una BD, luego usaremos aws-cli, subimos un backup a amazons3
- Creamos un contenedor de MySQL(5.7)
- Tener una cuenta en AWS y un budget disponible

Trabajamos nuevamente con nuestro archivo docker-compose.yml, y esta vez tendrá este contenido:

```version: '3'
services:
  jenkins:
    container_name: devjenkins
    image: jenkinsci/jenkins
    ports:
      - "8080:8080"
    volumes:
      - $PWD/jenkins:/var/jenkins_home
    networks:
      - net
  remote_host:
    container_name: devapp
    image: imgapp
    build:
      context: app
    networks:
      - net
  db_host:
    container_name: dbaws
    image: mysql:5.7
    environment:
      - "MYSQL_ROOT_PASSWORD=dbaws"
    volumes:
      - /home/docker/mysql:/var/lib/mysql
    networks:
      - net
networks:
  net:
```

Ejecutamos: **docker-compose up -d**  


![mysql](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmysql.png "mysql")


### OBS
para realizar las validaciones ( ip + acceso a la bd ) nos conectamos al conetenedor: **docker exec -it dbaws bash**


Bien, ahora dentro de app, vamos a modificar nuestro Dockerfile y quedará de la sgt forma:


```FROM centos

RUN yum -y install openssh-server net-tools epel-release

RUN useradd devuser && echo "1234" | passwd devuser  --stdin 

RUN yum -y install mysql

RUN yum -y install python-pip &&\
    pip install awscli

CMD /usr/sbin/sshd -D
```

Presto!!! ....  ejecutamos ahora **docker-compose build && docker-compose up -d**

Entramos al contenedor **devapp** y validamos aws y mysql

Posterior a ello vamos a copiar **sugar.sql** en el contenedor **dbaws** en la ruta /tmp

```$docker cp sugar.sql dbaws:/tmp/```

Entramos al contenedor dbaws y ejecutamos:


![mysql](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmysql1.png "mysql")

Y para el restore:

```$mysql -u root -p sugar < /tmp/sugar.sql```

### OBS
- El bucket tiene nombre: dbawsu
- El usuario ( IAM ): dbawsuser
- Se debe tener acceso a credentials.csv ( aqui estan los datos de acceso )


Bien, ahora vamos a copiar el script: backup.sh en /home/devuser 

```$docker cp backup.sh  devapp:/home/devuser/ 

Vamos a configurar el acceso via CLI a AWS de la siguiente forma ( contenedor: **devapp**  ):

```export AWS_ACCESS__kEY_ID=

export AWS_SECRET_ACCESS_KEY=
```

Para subirlo a nuestro bucket: 


```aws s3 cp /tmp/bk_sugar.sql s3://dbawsu```

Todo este procedimiento es de forma **manual**, vamos a verlo con Jenkins via un ***job***

- Creamos el job de nombre: **job-aws**
- Ejecutar/Execute shell script on remote host using ssh
- sh /home/devuser/backup.sh

![mysql](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmysql2.png "mysql")

Ejecutamos nuestro job:

![mysql](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmysql2.png "mysql")

![mysql](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmysql3.png "mysql")

![mysql](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmysql4.png "mysql")

Y validamos en bucket ( AWS) 

![mysql](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmysql5.png "mysql")



### Jenkins con ansible

Para ejecutar playbooks desde Jenkins, primero debemos tener instalado ansible en Jenkins, quien sera nuestro master.

en /home/docker, creamos la carpeta ansible, y dentro de el, creamos el Dockerfile


```FROM jenkinsci/jenkins

USER root

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python get-pip.py

RUN pip install -U ansible

USER jenkins
```

Ahora, este será nuestro docker-compose.yml


```version: '3'
services:
  jenkins:
    container_name: devjenkins
    image: jenkinsci/jenkins
    build:
      context: ansible     
    ports:
      - "8080:8080"
    volumes:
      - /home/docker/jenkins:/var/jenkins_home
    networks:
      - net
  remote_host:
    container_name: devapp
    image: imgapp
    build:
      context: app
    networks:
      - net
  db_host:
    container_name: dbaws
    image: mysql:5.7
    environment:
      - "MYSQL_ROOT_PASSWORD=1234"
    volumes:
      - /home/docker/mysql:/var/lib/mysql
    networks:
      - net
networks:
  net:
```

Compilamos y actualizamos los contenedores: ```$docker-compose build&&docker-compose up -d```


![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible.png "ansible")


Entramos al contenedor de jenkins y validamos: 


![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible1.png "ansible")


### OBS
- Si entramos al contenedor de jenkins, la carpeta **ansible** se encuentra en ***/var/jenkins_home/ansible***
- Vamos a copiar el archivo **hosts** en la ruta /home/docker/jenkins/ansible


El punto fuerte de ansible es que no necesita colocar contraseñas ni instalar cliente, por ello,vamos a crear llaves SSH para la conexión:

- cd /home/docker/jenkins
- chown 1000:1000 ansible
- docker exec -it devjenkins bash
- cd /var/jenkins_home/ansible
- **ssh-keygen**
- El resultado debe ser similar a esto:

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible3.png "ansible")

- Entramos al contendor **devapp** / docker exec -it devapp bash
- Creamos el usuario jenkins: useradd jenkins
- Ejecutamos con el usuario jenkins: ssh-keygen
- Creamos el fichero authorized_keys en /home/jenkins/.ssh
- Permisos: chmod go-rwx  authorized_keys
- Copiamos  *pub  de jenkins en authorized_keys en devapp para el usuario jenkins ojo!
- Validamos la conexion ssh desde jenkins

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible2.png "ansible")

Bien con las validaciones SSH de jenkins hacia devapp, vamos a probar un pequeño ping via ansible:
***ojo! ya copiamos hosts en /home/docker/jenkins/ansible***

En el contenedor de devjenkis, ejecutamos lo sgt:


```$ansible -m ping -i hosts app1```

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible3.PNG "ansible")

Vamos a ejecutar un playbook ( el nombre de nuestro playbook es prueba.yml, el cual esta en /home/docker/ansible )

```- hosts: app1
  tasks:
   - shell: echo $(date) > /tmp/horaa-ansible
```

Para entramos en el contenedor devjenkins:


![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible4.PNG "ansible")


Con estas pruebas básicas, vamos ahora a configurar Jenkins con Ansible:

- Administrar Jenkins/Administrar Plugins
- Todos los Plugins/Ansible

Ahora vamos a crear un job para ejecutar un **playbook**

### OBS
Se debe configurar el usuario jenkins en jenkins para que realice conexion SSH via llaves

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible5.PNG "ansible")

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible6.PNG "ansible")


- Nombre: job-ansible
- Ejecutar/Invoke Ansible Playbook

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible7.PNG "ansible")

- La configuracion sera asi:

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible8.PNG "ansible")

- Ejecutamos nuestro job

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsansible9.PNG "ansible")


### Jenkins con Git

Vamos a crear un contenedor Git Server e integrarlo con Jenkins


```version: '3'
services:
  jenkins:
    container_name: devjenkins
    image: jenkinsci/jenkins
    build:
      context: ansible     
    ports:
      - "8080:8080"
    volumes:
      - /home/docker/jenkins:/var/jenkins_home
    networks:
      - net
  remote_host:
    container_name: devapp
    image: imgapp
    build:
      context: app
    networks:
      - net
  db_host:
    container_name: dbaws
    image: mysql:5.7
    environment:
      - "MYSQL_ROOT_PASSWORD=1234"
    volumes:
      - /home/docker/mysql:/var/lib/mysql
    networks:
      - net
   git:
    container_name: git-server
    hostname: gitlab.example.com
    ports:
      - "443:443"
      - "8888:80"
    volumes:
      - "/home/docker/gitlab/config:/etc/gitlab"
      - "/home/docker/gitlab/logs:/var/log/gitlab"
      - "/home/docker/docker/gitlab/data:/var/opt/gitlab"
    image: gitlab/gitlab-ce
    networks:
      - net
networks:
  net:
```

### OBS
- Hacemos ahora: docker-compose up -d, este proceso demora 15mis aprox.
- El usuario para el logeo en gitlab es root

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab.png "gitlab")


Vamos a crear un grupo y un proyecto para alojar un pequeño codigo, asi como asignaremos persmisos para acceder al repositorio

**Create a group**

### OBS
Un grupo es una coleccion de varios proyectos!


![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab1.PNG "gitlab")


- **New Project**

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab2.PNG "gitlab")


- Creamos un nuevo usuario ( clic en la llave )

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab3.PNG "gitlab")


- Lo agregamos al grupo 


![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab4.PNG "gitlab")


![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab5.PNG "gitlab")


- Realizamos un clone del proyecto

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab6.PNG "gitlab")


![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab7.PNG "gitlab")


Para subir un codigo de prueba, vamos a clonar este proyecto (en /home/docker/:

**git clone https://github.com/jenkins-docs/simple-java-maven-app.git**

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab8.PNG "gitlab")

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab9.PNG "gitlab")


- Vamos a copiar el contenido de simple-java-maven-app a maven

### OBS

como paso previo:


```git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab12.PNG "gitlab")


- Para visualizar los archivos modificados, nuevos, ejecutamos **git status** dentro de la carpeta maven

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab10.PNG "gitlab")

- Agregamos todo el contenido: **git add .**

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab11.PNG "gitlab")

- Hacemos el commit: **git commit -m "Nuevos Cambios"**

- Y finalizamos con un: **git push**

![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab13.PNG "gitlab")


### OBS
- Realizar el mismo procedimiento para el usuario creado en gitlab

Validamos en gitlab nuestro codigo subido:


![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsgitlab14.PNG "gitlab")



### Jenkins con Maven

- En Jenkins instalamos el plugin para maven ( **maven integration** )
- Validar que el plugin de git se encuentre instalado.
- Creamos un nuevo proyecto: **job-ci**
- Crear el usuario "root" en Jenkins. ( este es el usuario **root de gitlab** )


![gitlab](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmaven.PNG "gitlab")


- Construir
- Validamos la salida

![maven](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/jenkinsmaven1.PNG "maven")


- Entrar al contenedor de jenkins y validar en la ruta la descarga del proyecto.

- Ahora vamos a interactuar con maven, **contruyendo codigo**. 



