# LABORATORIO 2

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

Todo nuestro trabajo ha sido realizado en el contendor de Jenkins, lo que es valido para ciertos trabajos, pero en un caso "real" es conectarnos
a un host/contenedor remoto y ejecutar jobs, para ello, vamos a crear previamente un contenedor, para trabajar con el y los jobs que despleguemos:







