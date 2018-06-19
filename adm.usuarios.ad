@echo off

:menu

cls

rem Configuro la apariencia del menu

echo =================== MENU =====================

echo Selecciona la tarea de administración deseada:

echo 1.-  Crear un  nuevo  usuario. 

echo 2.-  Crear un  nuevo grupo. 

echo 3.-  Crear una  unidad organizativa.

echo 4.-  Agregar  un usuario  a  un  grupo existente. 

echo 5.-  Eliminar un  usuario. 

echo 6.-  Listar  los  diferentes  grupos  del  dominio y sus respectivos integrantes.

echo fin.- Salir



rem Ahora configuro como va a redirigir cada opcion del menú

set /p opcion=%1



if %opcion%==1 goto :usuario

if %opcion%==2 goto :grupo

if %opcion%==3 goto :oniorg

if %opcion%==4 goto :usrgrp

if %opcion%==5 goto :delusr 

if %opcion%==6 goto :listar 

if %opcion%==fin goto fin



goto menu



rem Opcion de menú usuario

:usuario



cls

rem uso el compndo dsadd para cada una de las tareas usuario, grupo y unidad organizativa

echo =========== Creacion de usuario ==============

echo Cual es tu nombre del usuario ( no olvides introducir )?

rem mediante esta orden reclamo la entrada de teclado por parte del usuario

SET /P e=

rem agrego un usuario al directorio

dsadd user cn=%e%,cn=Users,dc=IGM,dc=local

@pause



goto :menu



:grupo



cls

echo ============ Creacion de grupo ==============

echo Cual es tu nombre del grupo?

SET /P g=

rem agrego un grupo al directorio

dsadd group cn=%g%,cn=Users,dc=IGM,dc=local

@pause



goto :menu



:oniorg



cls

echo ===== Creacion de unidad organizativa =======

echo Cual es el nombre de la unidad organizativa? 

SET /P u=

rem agrego una unidad organizativa al directorio

dsadd ou ou=%u%,dc=IGM,dc=local

@pause



goto :menu



:usrgrp

rem agrego un usuario a un grupo existente

cls

rem Para este caso muesro primero los grupos

echo ========== Agregar usuario a grupo ===========

echo Cual es el nombre del usuario previamente creado?

SET /P e=

echo  A continuacion muestro los grupos disponibles, si el grupo no existe, deberá crearlo antes:

rem dsquery hace una consulta al directorio activo.

dsquery group -o samid

echo Cual es tu nombre del grupo?

SET /P g=

rem utilizo ahora un nuevo comando para modificar los integrantes de un grupo ya existente

dsmod group cn=%g%,cn=Users,dc=IGM,dc=local -addmbr cn=%e%,cn=Users,dc=IGM,dc=local

@pause



goto :menu



:delusr 

rem En esta opción se usa dsrm para elmininar un ususario

cls

echo ============= Elmininar usuario ===============

Se muestra ahora el listado de usuarios:

dsquery user | dsget user -samid

echo Cual es tu nombre del usuario a eliminar?

SET /P d=

dsrm cn=%d%,cn=Users,dc=IGM,dc=local

@pause



goto :menu



:listar

rem utilizo de nuevo dsquery

cls

echo ======= Listado de grupos y usuarios  =========

echo Se listaran ahora los grupos:

@pause

dsquery group | dsget group -dn

@pause

echo Se listarán los usuarios de cada grupo

@pause

dsquery user | dsget user -dn

@pause



goto :menu
