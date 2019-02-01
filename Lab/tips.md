# Tips

En windows 10 PRO/ENTERPRISE se recomienda instalar:

- cmder
- Virtualbox 6 + Extension Pack
- docker toolbox ( sin virtualbox ) 
- docker-compose ( https://docs.docker.com/compose/install/ )
- Vagrant for Windows ( https://www.vagrantup.com/downloads.html )
- Bash Linux ( opcional )
- putty o similar ( si ya se cuenta con cmder o bash no es necesario ) 

En Linux se debe instalar: 

- Vagrant ( https://www.vagrantup.com/downloads.html )
- docker-ce ( https://docs.docker.com/install/linux/docker-ce/ubuntu/ )
- docker-compose  ( https://docs.docker.com/compose/install/ )

### OBJETIVO

En **Windows 10 Profesional y/o Enterprise** instalar docker se puede realizar de 2 formas:

- Docker para windows, el cual hace uso de Hyper-V
- Docker toolbox que, por medio de Virtualbox, nos crea una VM para interactuar con ella ( debemos instalar docker-compose ) 

En **Linux** la instalacion de docker es sencilla y más nativa.

```curl -fsSL https://get.docker.com -o get-docker.sh```

Script para eliminar TODO !!!!
```
#!/bin/bash
# Borrar contenedores en wuan!
docker rm $(docker ps -a -q)
# Borrar imanges tambien !!! 
docker rmi $(docker images -q)
echo "Lo hice :( "
```


