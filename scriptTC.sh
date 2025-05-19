#!/bin/bash

#Caso 1
interfaces_red(){
	echo "Interfaces de red en el equipo: "
	ifconfig
}
#Caso 2
paquetes_por_numero() {
	echo "Ingresa el nombre que deseas que tenga el archivo agregando su extension (.txt ...): "
	read -p "Archivo > " no_arch
	echo "Ingresa el nombre de la interfaz de la cual deseas capturar los datos "
	read -p "Interfaz > " no_interface
	echo "Ingresa la cantidad de paquetes que deseas: "
	read -p "Paquetes > " num_paquetes
	sudo tcpdump -c $num_paquetes -i $no_interface > $no_arch
}
#Caso 3
seleccion_interfaz(){
	echo "Ingresa el nombre de la interfaz de la cual deseas capturar los datos "
	read -p "Interfaz > " no_interface
	sudo tcpdump -v -i $no_interface
}
#Caso 4
captura_por_tipo(){
    echo "Selecciona el tipo de paquetes a capturar:"
    echo "1) TCP"
    echo "2) UDP"
    echo "3) ICMP"
    echo "4) ARP"
    echo "5) IP (cualquier tráfico IP)"
    read -p "Opción > " tipo_opcion

    case $tipo_opcion in
        1) filtro="tcp";;
        2) filtro="udp";;
        3) filtro="icmp";;
        4) filtro="arp";;
        5) filtro="ip";;
        *) echo "Opción no válida"; return;;
    esac

    echo "Ingresa el nombre de la interfaz de la cual deseas capturar los paquetes:"
    read -p "Interfaz > " no_interface

    echo "Iniciando captura de tráfico $filtro en la interfaz $no_interface..."
    sudo tcpdump -i "$no_interface" $filtro
}

#Caso 5
captura_en_ascii() {
	echo "Ingresa el nombre de la interfaz de la cual deseas capturar los datos "
	read -p "Interfaz > " no_interface
	sudo tcpdump -x -v -i $no_interface
}
#Caso 6
captura_fecha(){
	echo "Ingresa el nombre de la interfaz de la cual deseas capturar los datos "
	read -p "Interfaz > " no_interface
	sudo tcpdump  -i $no_interface -tttt
}
#Caso 7
captura_pcap(){
	echo "Ingresa el nombre que deseas que tenga el archivo con extension .pcap"
	read -p "Archivo > " no_arch
	echo "Ingresa el nombre de la interfaz de la cual deseas capturar los datos "
	read -p "Interfaz > " no_interface
	sudo tcpdump -i $no_interface > $no_arch
}
#Caso 8
filtrar_ip(){
    echo "Especifica la interfaz de la que quieres capturar tráfico"
    read -p "Interfaz > " no_interface

    echo "Selecciona una de las opciones:"
    echo "1) Filtrar por dirección IP específica"
    echo "2) Solo filtrar tráfico de origen de una IP específica"
    echo "3) Solo filtrar tráfico de destino a una IP específica"
    echo "4) Filtrar por rango de IP en subred (/24, /16, etc.)"
    echo "5) Filtrar tráfico entre una IP de origen y una de destino"
    echo "6) Capturar todo el tráfico IP"

    read -p "Opción > " tipo_opcion

    case $tipo_opcion in
        1)  echo "Ingresa la dirección IP específica"
            read -p "Dirección > " no_direccion
            filtro="host $no_direccion"
            ;;
        2)  echo "Ingresa la dirección IP de origen"
            read -p "Dirección > " no_direccion
            filtro="src host $no_direccion"
            ;;
        3)  echo "Ingresa la dirección IP de destino"
            read -p "Dirección > " no_direccion
            filtro="dst host $no_direccion"
            ;;
        4)  echo "Ingresa la red en formato CIDR (Ejemplo: 192.168.1.0/24)"
            read -p "Red > " no_red
            filtro="net $no_red"
            ;;
        5)  echo "Ingresa la dirección IP de origen"
            read -p "IP Origen > " ip_origen
            echo "Ingresa la dirección IP de destino"
            read -p "IP Destino > " ip_destino
            filtro="src host $ip_origen and dst host $ip_destino"
            ;;
        6)  filtro="ip"
            ;;
        *)  echo "Opción no válida"; return
            ;;
    esac

    echo "Iniciando captura de tráfico con filtro: $filtro en la interfaz $no_interface..."
    sudo tcpdump -i "$no_interface" -n -tttt $filtro
}

#Caso 9
filtrar_puerto(){
	echo "1) Capturar tráfico de un puerto específico"
	echo "2) Capturar tráfico de un tipo de puerto (TCP/UDP)"
	echo "3) Capturar tráfico en un rango de puertos"
	echo "4) Capturar tráfico con puerto origen/destino"
	echo "5) Salir"
	read -p "Opcion > " opcion
	
	case $opcion in
	  1)
	    echo "Ingresa el puerto del que quieres capturar"
	    read -p  "Puerto > " port
	    tcpdump -i eth0 -n port $port
	    ;;
	  2)
	    echo "Capturar tráfico TCP o UDP? (tcp/udp)"
	    read -p "Opcion >" proto
	    tcpdump -i eth0 -n $proto
	    ;;
	  3)
	    echo "Ingresa el puerto mínimo: "
	    read -p "Puerto > " min_port
	    
	    echo "Ingresa el puerto maximo "
	    read -p "Puerto > " max_port
	    tcpdump -i eth0 -n portrange $min_port-$max_port
	    ;;
	  4)
	    read -p "Ingresa el puerto origen: " src_port
	    read -p "Ingresa el puerto destino: " dst_port
	    tcpdump -i eth0 -n src port $src_port and dst port $dst_port
	    ;;
	  5)
	    exit 0
	    ;;
	  *)
	    echo "Ingresa otra  opcion"
	    ;;
	esac
	
}
#Caso 10
paquete_destinoIP() {
    echo "Ingresa la IP de destino:"
    read -p "Dirección > " dst_ip

    echo "Ingresa el puerto de destino:"
    read -p "Puerto > " dst_port

    echo "Capturando tráfico con destino $dst_ip:$dst_port..."
    sudo tcpdump -i eth0 -n -tttt dst host "$dst_ip" and dst port "$dst_port"
}

#Caso 11
usuario_destino(){
    echo "Ingresa la IP de destino:"
    read -p "Dirección > " dst_ip

    echo "Capturando tráfico con destino $dst_ip en puertos 80 y 443..."
    sudo tcpdump -i eth0 -n -tttt dst host "$dst_ip" and \( dst port 80 or dst port 443 \)
}

#Caso 12
size_paquete() {
	echo "Ingresa el nombre de la interfaz de la cual deseas capturar los datos "
	read -p "Interfaz > " no_interface
	echo "Ingresa el volumen de los paquetes que deseas capturar> "
	read -p "Volumen > " vol
	sudo tcpdump  -i $no_interface -n -tttt greater $vol
}


while true; do
    echo " "
    echo "MENU"
    echo "	1. Mostrar interfaces de red disponibles"
    echo "	2. Capturar número de paquetes deseados y enviar el resultado a un archivo."
    echo "	3. Selección de interfaz para captura de paquetes en general"
    echo "	4. Seleccionar el tipo de paquetes a capturar"
    echo "	5. Mostrar solo paquetes en ASCII"
    echo "	6. Capturar con fecha de captura el tráfico de red"
    echo "	7. Guardar la captura en un archivo de extensión .pcap"
    echo "	8. Filtrar por dirección IP (host) / rangos (net) destino, origen y destino + origen"
    echo "	9. Filtrar por puerto / tipo de puerto / rango de puertos origen, destino, origen + destino."
    echo "   (Mostrando IP y puerto)."
    echo "	10. Capturar cualquier paquete con destino IP capturada por el usuario (IP y puerto)"
    echo "	11. Capturar paquetes con IP destino capturada por el usuario con destino"
    echo "	12. Capturar tráfico filtrando por tamaño del paquete."
    echo "	13. Salir"
    read -p "Opción: " option

    case $option in
        1) 
            interfaces_red
            exit 0
            ;;
        2) 
            paquetes_por_numero
            exit 0
            ;;
        3) 
            seleccion_interfaz
            exit 0
            ;;
        4) 
            captura_por_tipo
            exit 0
            ;;
        5) 
            captura_en_ascii
            exit 0
            ;;
        6) 
            captura_fecha
            exit 0
            ;;
        7) 
            captura_pcap
            exit 0
            ;;
        8) 
            filtrar_ip
            exit 0
            ;;
        9) 
            filtrar_puerto
            exit 0
            ;;
        10) 
            paquete_destinoIP
            exit 0
            ;;
        11) 
            usuario_destino
            exit 0
            ;;
        12) 
            size_paquete
            exit 0
            ;;
        13) 
            exit 0
            ;;
        *) 
            echo "La opción ingresada no es válida"
            ;;
    esac
done

