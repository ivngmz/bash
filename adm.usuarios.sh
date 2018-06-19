#!/bin/bash
# Menu shell script Administracion de usuarios Ubuntu
 
# Defino variables
LSB=/usr/bin/lsb_release
 
# Proposito: Realizar una pausa
function pause(){
	local message="$@"
	[ -z $message ] && message="Presione [Enter] para continuar"
	read -p "$message" readEnterKey
}
 
# Proposito: Mostrar Menu
function mostrar_menu(){
    date
    echo "----------------------------------------------------------------------"
    echo "           ADMINISTRACION DE USUARIOS Y GRUPOS DEL SISTEMA            "
    echo "----------------------------------------------------------------------"
	echo "1. Crear un nuevo usuario."
	echo "2. Crear un nuevo grupo."
	echo "3. Cambiar la clave de un usuario."
	echo "4. Agregar un usuario a un grupo existente."
	echo "5. Eliminar un usuario."
	echo "6. Listar los diferentes grupos locales y sus respectivos integrantes."
	echo "7. Salir"
}
 
# Proposito: Mostrar un mensaje de cabecera
function write_header(){
	local h="$@"
	echo "---------------------------------------------------------------"
	echo "     ${h}"
	echo "---------------------------------------------------------------"
}
 
# Proposito - Crear un nuevo usuario
function crear_usr(){
	clear
	write_header " Crear un nuevo usuario "
	echo "A continuacion se le solicita nombre de usuario y contraseña"
	echo ""
	# Compruebo que el ususario el administrador
	if [ $(id -u) -eq 0 ]; then
		# Solicito la entrada desde teclado al usuario
		read -p "Ingrese el nombre de usuario: " username
		read -s -p "Ingrese la contraseña: " password
		# Compruebo que el usuario existe
		egrep "^$username" /etc/passwd >/dev/null
		if [ $? -eq 0 ]; then
			echo "$username ya existe!"
			exit 1
		# Si no existe lo creo
		else
			pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
			useradd -m -p $pass $username
			echo ""
			[ $? -eq 0 ] && echo "El usuario se ha agregado al sistema!" || echo "No se ha podido agregar el usuario!"
		fi
	# Caso de que el usuario no sea administrador aviso
	else
		echo "Unicamente el administrador puede agregar un usuario al sistema"
		exit 2
	fi 
pause
}
 
# Proposito - Get info about host such as dns, IP, and hostname
function crear_grp(){
	clear
	write_header " Crear un nuevo grupo "
	# Compruebo que el ususario el administrador	
	if [ $(id -u) -eq 0 ]; then
		read -p "Ingrese el nombre de grupo: " groupname
		# Compruebo que el grupo existe
		egrep "$groupname" /etc/passwd >/dev/null
		if [ $? -eq 0 ]; then
			echo "$groupname ya existe!"
			exit 1
		# Si no existe lo creo
		else
			groupadd $groupname
			echo ""
			[ $? -eq 0 ] && echo "El grupo se ha agregado al sistema!" || echo "No se ha podido agregar el grupo!"
		fi
# Caso de que el usuario no sea administrador aviso
else
	echo "Unicamente el administrador puede agregar un grupo al sistema"
	exit 2
fi 
pause
}
 
# Proposito - Modificar la clave de un usuario
function mod_clave(){
	clear
	# Compruebo que el ususario el administrador
	if [ $(id -u) -eq 0 ]; then
		write_header " Cambiar la clave de un usuario "
		echo "Muesto ahora los nombres de usuario"
		tail /etc/passwd | cut -d":" -f1
		echo ""
		read -p "Ingrese el nombre de usuario: " username
		passwd $username
		pause 
	# Caso de que el usuario no sea administrador aviso
	else
		echo "Unicamente el administrador puede agregar un grupo al sistema"
		exit 2
	fi 
}
 
# Proposito - Incluir un usuario en un grupo  
function usr_to_grp(){
	clear
	# Compruebo que el ususario el administrador
	if [ $(id -u) -eq 0 ]; then
		write_header " Agregar un usuario a un grupo existente "
		echo "Muestro inicialmente el listado de grupos existente:"
		tail /etc/group | cut -d":" -f1
		echo ""
		read -p "Ingrese el nombre de grupo: " groupname
		echo ""
		echo "Muestro el listado de usuarios ahora: "
		echo ""
		tail /etc/passwd | cut -d":" -f1
		echo ""
		read -p "Ingrese el nombre de usuario: " username
		usermod -a -G $groupname $username
		pause
	# Caso de que el usuario no sea administrador aviso
	else
		echo "Unicamente el administrador puede agregar un grupo al sistema"
		exit 2
	fi 	
}
 
# Proposito - Borrar un usuario existente
function del_usr(){
	clear
	# Compruebo que el ususario el administrador
	if [ $(id -u) -eq 0 ]; then
		write_header " Eliminar un usuario "
		echo "Muestro ahora la lista de usuarios"
		echo ""
		tail /etc/passwd | cut -d":" -f1
		echo ""
		read -p "Ingrese el nombre de usuario: " username
		userdel -r $username
		pause
	# Caso de que el usuario no sea administrador aviso
	else
		echo "Unicamente el administrador puede agregar un grupo al sistema"
		exit 2
	fi 
}

# Proposito - Listar usuarios y grupos
function listar(){
	clear
	# Compruebo que el ususario el administrador
	if [ $(id -u) -eq 0 ]; then
		write_header " Listar los diferentes grupos locales y sus respectivos integrantes "
		for i in $(tail /etc/group  | cut -d: -f1); do
			echo -n $i "     -->        "
			grep $i /etc/passwd | cut -d: -f1 | tr "\n" " "
			echo ""
		done
		pause
	# Caso de que el usuario no sea administrador aviso
	else
		echo "Unicamente el administrador puede agregar un grupo al sistema"
		exit 2
	fi 
}
# Proposito - Conseguir la entrada de usuario para la eleccion de la funcion
function leer_entrada(){
	local c
	read -p "Elija una opcion [ 1 - 7 ] " c
	case $c in
		1)	crear_usr ;;
		2)	crear_grp ;;
		3)	mod_clave ;;
		4)	usr_to_grp ;;
		5)	del_usr ;;
		6)	listar ;;
		7)	echo "Hata otra!"; exit 0 ;;
		*)	
			echo "Please select between 1 to 7 choice only."
			pause
	esac
}
 
# ignorar CTRL+C, CTRL+Z and quit singles usando trap
trap '' SIGINT SIGQUIT SIGTSTP
 
# logica principal
while true
do
	clear
 	mostrar_menu	# mostrar menu de opcciones
 	leer_entrada  # esperar para la eleccion de usuario
	clear
done

