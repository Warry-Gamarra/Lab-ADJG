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


### Git/GitHub


Pues bien vamos ahora crear una imagen y subirla a dockerhub, los archivos de configuracion serán subidos a Github.

Vamos a instalar la imagen de **ubuntu** y en base a el, vamos a iniciar nuestro contenedor de nombre **"devubuntu"**


![alphine](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockerubuntu.png "ubuntu")


Ahora vamos a iniciar nuestro contenedor :

```$docker run -it --name devubuntu ubuntu bash```


![contenedor](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/deockerrun.png "Contenedor ubuntu")


Dentro del contenedor vamos a crear la carpeta datos en /opt y vamos a crear el usuario devubuntu con password devubuntu


![contenedor](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockerdevu.png "Contenedor ubuntu")


Procedemos a salir del contenedor, y vamos hacer un commit, para ello tenemos que saber cual es el ID del **contenedor**, ejecutamos lo sgt:

**$docker ps -a**


![container](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockeridcontainer.png "Id container")


Procedemos hacer commit en base al **ID del contenedor**


```$docker commit ID NAME_PROJECT```


![commit](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockercommit.png "Commit")


Para subir nuestra imagen a DockerHub, hacemos login en la consola: ```$docker login $USER```

Colocamos nuestros datos 


![Login](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockerlogin.png "Login")


Con el login realizado, vamos a identificar previamente el id para poder subir la imagen ( taggeo ):

![tag](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockertag.png "tag")

```$docker tag $ID USER_DOCKERHUB/NAME:IMAGE_NAME```


![tag id](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockertagid.png "tagid")


Usamos ahora un push para subirlo:

```$docker push USER_DOCKERHUB/NAME:IMAGE_NAME```


![push](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockerpush1.png "push")


Nos logeamos en la web de dockerhub y validamos:


![dockerhub](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/dockerhub.png "dockerhub")


## Vagrant & Ansible

Vagrant nos permite "crear" infraestructura por medio de "codigo" lo que se conoce como IcA, Ansible nos permite realizar configuraciones centralizadas sin la necesidad de interactuar directamente con los servidores.

Ambas herramientas combinadas nos permiten desplegar infraestrucutra en menor tiempo, asi como las configuraciones que necesitemos. 

En la ruta ***C:\vagrant*** será nuestro directorio donde vamos a trabajar con vagrant, para ello vamos previamente a ejecutar **vagrant init**, lo que hace el comando es crear el archivo **Vagrantfile** base.

Vamos a trabajar con el archivo Vagrantfile que esta adjunto a la guia

Para que vagrant "compile", realizaremos esto:

![vagrant](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/vagrant.png "Vagrant")

Como resultado, debemos llegar :

![vagrant](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/vagrant1.PNG "Vagrant")


Validamos en Virtualbox:


![vagrant](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/vagrant2.PNG "Vagrant")

Si queremos conectarnos a la VM creada:

![vagrant](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/vagrant3.PNG "Vagrant")

![vagrant](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/vagrant4.PNG "Vagrant")


Si queremos setear desde el archivo Vagrantfile el password para el usuario root:


``` config.ssh.username= 'root'
    config.ssh.password= 'vagrant'
    config.ssh.insert_key= 'true'
```

Ahora vamos a crear de un solo golpe 3 vms, 1 master y 2 nodos,   para ello vamos a usar Vagranfile2

Una vez terminada la creación de la infraestructura, listemos los nodos:


```$vagrant status```

Para conectarnos via SSH a cualquiera de los servidores:



![vagrant](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/vagrant5.PNG "Vagrant")




Seguimos estos pasos previos:

- vagrant plugin install vagrant-scp 
- En master: mkdir -p /home/vagrant/ansible
- vagrant scp ansible.cfg master:/home/vagrant/ansible
- ssh-keygen -t rsa "en los nodos master, 1 y 2"
- Copiar el id_rsa.pub de master en el fichero authorized_keys en nodo1 y 2.
- Validar el ssh sin que pida password. ( el usuario debe ser vagrant )
- Configurar "sudoers" para poder usar **sudo**
- En todos los nodos ( como usuario root ):

```vi /etc/sudoers.d/ansible
   vagrant ALL=(ALL) NOPASSWD: ALL
```

### OBS
Se puede usar vagrant scp para realizar esta tarea... 


Vamos ahora a configurar un playbook sencillo para validar el PING a los nodos, el cual será de la sgt manera, pero primero creamos nuestro inventario de hosts:

- touch inventario


```
[all]
node1 
node2
master

[nodos]
node1
node2
```

- Ahora ejecutamos: ***ansible all -m ping -i inventario***

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/ansible.PNG "ansible")


- Un comando sencillo de ejecutar seria: ***ansible all -m command -a id***

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/ansible1.PNG "ansible")


- Otra ejecución seria: ***ansible all -m copy -a 'content="Ansible Configuration\n" dest=/etc/motd'***

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/ansible2.PNG "ansible")

### OBS

Ejecuta la sentencia para obtener los hostname de todos los servidores


Bien, como pudieron apreciar, podemos ejecutar cualquier comando de forma centralizada, ahora vamos a instalar vim en master y en los nodos la carpeta backup
Por ello vamos a ver la estructura de un **playbook**

- En /home/vagrant/ansible, vamos a copiar el fichero install.yml
- Lo ejecutamos: ***ansible-playbook install.yml***

![ansible](https://github.com/kdetony/Lab-ADJG/blob/master/Lab/imagenes/ansible3.PNG "ansible")


De esta forma podemos realizar las configuraciones que deseemos de forma sencilla.



## Caso Practico:

La empresa ACME SAC te ha contratado para realizar el despliegue de infraestructura en su nuevo ambiente de Desarrollo ( testing ), con los conocientos que tienes y debido a las limitantes en la empresa, ofreces implementar el siguiente stack tecnológico: **Virtualbox, docker, ansible y Git.**


El gerente de sistema compra tu idea y te pide lo sgt:


- 1 VM para administrar y desplegar las configuraciones hacia futuros servidores.
- 1 VM con Mysql ( base de datos ) crear el usuario "dba" y la carpeta deploy en /opt
- Crear 3 imagenes docker de nombre "acmebase", "acmedev" y "acmeprd" en base a Centos7 y subirla a DockerHub. ( acmeprd debe tener instalado Apache, acmedev debe tener instalado php )
- Los archivos como por ejm. Dockerfile y docker-compose deben estar en GitHub para poder ser versionados en un futuro.
- ***No puedes usar shell scripting para realizar estas tareas ya que tienes que demostrar que dominas los temas que propusiste.***
