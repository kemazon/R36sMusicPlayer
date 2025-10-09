#!/bin/bash

JOYSTICK_DEVICE="/dev/input/event2"

if [ "$(whoami)" != "ark" ]; then
    echo "Este script debe ejecutarse como el usuario 'ark'."
    exit 1
fi

# Define la contraseña del usuario "ark" si es necesario
password="ark"

echo "$password" | su - ark -c "sleep 86400 & "

#Bucle infinito para mantener la sesión activa
while true; do
 #Inicia la sesión utilizando un comando que no finalice
 #Por ejemplo, simplemente espera hasta que se cierre la sesión
echo '123'
sleep 86400  # Espera un día (86400 segundos) antes de volver a comprobar
done & 


#sudo pulseaudio --disallow-exit & 

# Bucle para leer eventos del joystick
evtest "$JOYSTICK_DEVICE" | while read -r line; do
    # Filtrar y procesar las pulsaciones de botones aquí...
    if [[ $line == *"BTN_TRIGGER_HAPPY5), value 1"* ]]; then
        touch /tmp/btn1press
    elif [[ $line == *"BTN_TRIGGER_HAPPY5), value 0"* ]]; then
        rm /tmp/btn1press
    fi
    
    if [[ $line == *"BTN_TRIGGER_HAPPY2), value 1"* ]]; then
        touch /tmp/btn2press
    elif [[ $line == *"BTN_TRIGGER_HAPPY2), value 0"* ]]; then
        rm /tmp/btn2press
    fi
    
    if [[ $line == *"BTN_TRIGGER_HAPPY1), value 1"* ]]; then
        touch /tmp/btn3press
    elif [[ $line == *"BTN_TRIGGER_HAPPY1), value 0"* ]]; then
        rm /tmp/btn3press
    fi
    
    if [[ $line == *"BTN_DPAD_RIGHT), value 1"* ]]; then
        touch /tmp/btn4press
    elif [[ $line == *"BTN_DPAD_RIGHT), value 0"* ]]; then
        rm /tmp/btn4press
    fi
    
    if [[ $line == *"BTN_TRIGGER_HAPPY3), value 1"* ]]; then
        touch /tmp/btn5press
    elif [[ $line == *"BTN_TRIGGER_HAPPY3), value 0"* ]]; then
        rm /tmp/btn5press
    fi

    if [[ $line == *"(BTN_TL2), value 1"* ]]; then
        touch /tmp/btn6press
    elif [[ $line == *"(BTN_TL2), value 0"* ]]; then
        rm /tmp/btn6press
    fi

    if [[ $line == *"(BTN_TR2), value 1"* ]]; then
        touch /tmp/btn7press
    elif [[ $line == *"(BTN_TR2), value 0"* ]]; then
        rm /tmp/btn7press
    fi
	
	if [[ $line == *"(BTN_DPAD_LEFT), value 1"* ]]; then
        touch /tmp/btn8press
    elif [[ $line == *"(BTN_DPAD_LEFT), value 0"* ]]; then
        rm /tmp/btn8press
    fi
	
	if [[ $line == *"(BTN_DPAD_UP), value 1"* ]]; then
        touch /tmp/btn9press
    elif [[ $line == *"(BTN_DPAD_UP), value 0"* ]]; then
        rm /tmp/btn9press
    fi
	
	if [[ $line == *"(BTN_DPAD_DOWN), value 1"* ]]; then
        touch /tmp/btn10press
    elif [[ $line == *"(BTN_DPAD_DOWN), value 0"* ]]; then
        rm /tmp/btn10press
    fi
	
	if [[ $line == *"(BTN_NORTH), value 1"* ]]; then
        touch /tmp/btn11press
    elif [[ $line == *"(BTN_NORTH), value 0"* ]]; then
        rm /tmp/btn11press
    fi
	
	if [[ $line == *"(BTN_SOUTH), value 1"* ]]; then
        touch /tmp/btn12press
    elif [[ $line == *"(BTN_SOUTH), value 0"* ]]; then
        rm /tmp/btn12press
    fi

	if [[ $line == *"(BTN_WEST), value 1"* ]]; then
        touch /tmp/btn13press
    elif [[ $line == *"(BTN_WEST), value 0"* ]]; then
        rm /tmp/btn13press
    fi	

	if [[ $line == *"(BTN_EAST), value 1"* ]]; then
        touch /tmp/btn14press
    elif [[ $line == *"(BTN_EAST), value 0"* ]]; then
        rm /tmp/btn14press
    fi

    if [[ $line == *"(ABS_RY), value 1800"* ]]; then
        touch /tmp/btn15press
    elif [[ $line == *"(ABS_RY), value 0"* ]]; then
        rm /tmp/btn15press
    fi
	
	if [[ $line == *"(ABS_RY), value -1800"* ]]; then
        touch /tmp/btn16press
    elif [[ $line == *"(ABS_RY), value 0"* ]]; then
        rm /tmp/btn16press
    fi
	
	if [[ $line == *"(BTN_TR), value 1"* ]]; then
        touch /tmp/btn17press
    elif [[ $line == *"(BTN_TR), value 0"* ]]; then
        rm /tmp/btn17press
    fi
	
	if [[ $line == *"(BTN_TL), value 1"* ]]; then
        touch /tmp/btn18press
    elif [[ $line == *"(BTN_TL), value 0"* ]]; then
        rm /tmp/btn18press
    fi
	
	if [[ $line == *"(BTN_TRIGGER_HAPPY4), value 1"* ]]; then
        touch /tmp/btn19press
    #elif [[ $line == *"(BTN_TRIGGER_HAPPY4), value 0"* ]]; then
     #   rm /tmp/btn19press
    fi
	
	
	if [[ $line == *"(ABS_RX), value 1800"* ]]; then
        touch /tmp/btn20press
    #elif [[ $line == *"(ABS_RX), value 0"* ]]; then
     #   rm /tmp/btn20press
    fi
	
	if [[ $line == *"(ABS_RX), value -1800"* ]]; then
        touch /tmp/btn21press
    #elif [[ $line == *"(ABS_RX), value 0"* ]]; then
     #   rm /tmp/btn21press
    fi




# Ejecutar acciones, según los botones usados
	
	# Verificar si se presionaron los botones 1 y 2 simultáneamente (PLAY/PAUSE)
    if test -e /tmp/btn1press && test -e /tmp/btn2press; then
		echo 'cycle pause' | socat - /tmp/mpvsocket
        rm -f /tmp/btn1press /tmp/btn2press
    fi

    # Verificar si se presionaron los botones 1 y 3 simultáneamente (STOP)
    if test -e /tmp/btn1press && test -e /tmp/btn3press; then
        echo 'keypress q' | socat - /tmp/mpvsocket
		echo 'quit' | socat - /tmp/mpvsocket
		killall Musica_Play.sh
		killall Musica_Play_Player.sh
		killall ffplay
        echo "Saliendo..."
		
		#Subir el CPU
		sudo echo interactive | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		sudo echo interactive | sudo tee /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
		sudo echo interactive | sudo tee /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
		sudo echo interactive | sudo tee /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
        rm -f /tmp/btn1press /tmp/btn3press
    fi

    # Verificar si se presionaron los botones 1 y 4 simultáneamente (SIGUIENTE)
    if test -e /tmp/btn1press && test -e /tmp/btn4press; then
		echo 'keypress next' | socat - /tmp/mpvsocket
		#echo 'show-text ${filename}' | socat - /tmp/mpvsocket
        rm -f /tmp/btn4press
    fi

    # Verificar si se presionaron los botones 1 y 5 simultáneamente (PANTALLA OFF)
    if test -e /tmp/btn1press && test -e /tmp/btn5press; then
        if [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -gt 0 ]; then
            cat /sys/devices/platform/backlight/backlight/backlight/brightness > /tmp/brightness
			for ((i="$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)"; i>=0; i-=10)); do
				echo "$i" > /sys/devices/platform/backlight/backlight/backlight/brightness
				sleep 0.03
			done
			echo "0" > /sys/devices/platform/backlight/backlight/backlight/brightness
			echo powersave | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
			echo powersave | sudo tee /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
			echo powersave | sudo tee /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
			echo powersave | sudo tee /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
			echo 1008000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        elif [ "$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)" -eq 0 ]; then
			for ((i=0; i<="$(cat /tmp/brightness)"; i+=10)); do
				echo "$i" > /sys/devices/platform/backlight/backlight/backlight/brightness
				sleep 0.03
			done
			echo "$(cat /tmp/brightness)" > /sys/devices/platform/backlight/backlight/backlight/brightness  # Asegurar el valor final
			echo interactive | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
			echo interactive | sudo tee /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
			echo interactive | sudo tee /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
			echo interactive | sudo tee /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
            #cat /tmp/brightness > /sys/devices/platform/backlight/backlight/backlight/brightness
        fi
        rm -f /tmp/btn1press /tmp/btn5press
    fi
	
	if [ -e /tmp/btn5press ] && pgrep -x "IPTV.sh" > /dev/null; then
		echo 'keypress A' | socat - /tmp/mpvsocket
		rm -f /tmp/btn5press
	fi

    if test -e /tmp/btn1press && test -e /tmp/btn6press; then
        sudo nmcli radio all on
        rm -f /tmp/btn1press /tmp/btn6press
    fi

    if test -e /tmp/btn1press && test -e /tmp/btn7press; then
        sudo nmcli radio all off
        rm -f /tmp/btn1press /tmp/btn7press
    fi
	
	if test -e /tmp/btn1press && test -e /tmp/btn8press; then
        echo 'keypress prev' | socat - /tmp/mpvsocket
		#echo 'show-text ${filename}' | socat - /tmp/mpvsocket
        rm -f /tmp/btn8press
    fi
	
	if test -e /tmp/btn1press && test -e /tmp/btn9press; then
        echo 'seek 15' | socat - /tmp/mpvsocket
        rm -f /tmp/btn9press
    fi
	
	if test -e /tmp/btn1press && test -e /tmp/btn10press; then
		echo 'seek -15' | socat - /tmp/mpvsocket
        rm -f /tmp/btn10press
    fi
	
	if test -e /tmp/btn1press && test -e /tmp/btn11press; then
        echo 'show-text ${filename}' | socat - /tmp/mpvsocket
        rm -f /tmp/btn1press /tmp/btn11press
    fi

	if test -e /tmp/btn1press && test -e /tmp/btn12press; then
        echo 'keypress i' | socat - /tmp/mpvsocket
        rm -f /tmp/btn1press /tmp/btn12press
    fi

	if test -e /tmp/btn1press && test -e /tmp/btn13press; then
        echo 'keypress Alt+m' | socat - /tmp/mpvsocket
		rm -f /tmp/btn1press /tmp/btn13press
    fi
	
	if test -e /tmp/btn1press && test -e /tmp/btn14press; then
		archivo="/roms2/music/playlist.m3u"

		# Contar archivos en la carpeta
		num_archivos=$(find /roms2/music -type f \( -name "*.m4a" -o -name "*.mp4" -o -name "*.ogg" -o -name "*.mp3" -o -name "*.aac" \) | wc -l | tr -d ' ')

		# Verificar si el archivo playlist.m3u existe
		if [ ! -f "$archivo" ]; then
			num_lineas=0
		else
			# Contar líneas, ignorando líneas vacías y comentarios
			num_lineas=$(grep -v -e '^$' -e '^#' "$archivo" | wc -l | tr -d ' ')
		fi

		# Verificar que las variables sean números válidos
		if ! [[ "$num_archivos" =~ ^[0-9]+$ ]]; then
			echo "Error: num_archivos no es un número válido."
			exit 1
		fi
		if ! [[ "$num_lineas" =~ ^[0-9]+$ ]]; then
			echo "Error: num_lineas no es un número válido."
			exit 1
		fi

		# Comparar y actualizar solo si hay cambios
		if [ "$num_archivos" -ne "$num_lineas" ]; then
			# Actualizar el archivo playlist.m3u
			find /roms2/music -type f \( -name "*.m4a" -o -name "*.mp4" -o -name "*.ogg" -o -name "*.mp3" -o -name "*.aac" \) | sort > "$archivo"
			echo "show-text \"Se actualizó el playlist, tienes $num_archivos archivos\"" | socat - /tmp/mpvsocket
		else
			echo "show-text \"No hay cambios en tu playlist, \ntienes ${num_archivos} archivos\"" | socat - /tmp/mpvsocket
		fi
		rm -f /tmp/btn1press /tmp/btn13press
    fi

	
	if test -e /tmp/btn1press && test -e /tmp/btn15press; then
        echo 'keypress p' | socat - /tmp/mpvsocket
        rm -f /tmp/btn1press /tmp/btn15press
    fi
	
	if [ -e /tmp/btn16press ] && pgrep -x "Musica_Play_Player.sh" > /dev/null; then
		charge=$(cat /sys/class/power_supply/battery/capacity)
        #echo 'show-text "${osd-ass-cc/0}{\\fscx200\\fscy200}\n\n\n\n\n\n\n\n${clock}         🔋$(cat /sys/class/power_supply/battery/capacity)%{\\fscx100\\fscy100\\an5}"' | socat - /tmp/mpvsocket
		echo 'show-text "${osd-ass-cc/0}{\\fscx200\\fscy200}\n\n\n\n\n\n\n\n${clock}      ⚡'$(cat /sys/class/power_supply/battery/capacity)'%{\\fscx100\\fscy100\\an5}"' | socat - /tmp/mpvsocket
        rm -f /tmp/btn16press
    fi
	
	if [ -e /tmp/btn15press ] && pgrep -x "IPTV.sh" > /dev/null; then
		echo 'keypress DOWN' | socat - /tmp/mpvsocket
		rm -f /tmp/btn15press
	fi
	
	if [ -e /tmp/btn16press ] && pgrep -x "IPTV.sh" > /dev/null; then
		#echo 'keypress p' | socat - /tmp/mpvsocket
		echo 'keypress UP' | socat - /tmp/mpvsocket
		rm -f /tmp/btn16press
	fi
	
	if [ -e /tmp/btn19press ]&& pgrep -x "IPTV.sh" > /dev/null; then
		echo 'keypress p' | socat - /tmp/mpvsocket
        echo 'keypress ENTER' | socat - /tmp/mpvsocket
        rm -f /tmp/btn19press
    fi
	
	if [ -e /tmp/btn20press ]&& pgrep -x "IPTV.sh" > /dev/null; then
		echo 'keypress RIGHT' | socat - /tmp/mpvsocket
        rm -f /tmp/btn20press
    fi
	
	if [ -e /tmp/btn21press ]&& pgrep -x "IPTV.sh" > /dev/null; then
		echo 'keypress LEFT' | socat - /tmp/mpvsocket
        rm -f /tmp/btn21press
    fi


	
	if test -e /tmp/btn1press && test -e /tmp/btn17press; then
        echo 'keypress Alt+r' | socat - /tmp/mpvsocket
		wget "https://www.virtualsmarthome.xyz/url_routine_trigger/activate.php?trigger=8c3b0167-b12d-4213-bd40-f818300d8a65&token=c5915941-b010-49b5-af1d-8adb223fd98e&response=json"
		#echo 'show-text "${osd-ass-cc/0}Letra..."' | socat - /tmp/mpvsocket
        rm -f /tmp/btn1press /tmp/btn17press
    fi
	
	if test -e /tmp/btn1press && test -e /tmp/btn18press; then
        wget "https://www.virtualsmarthome.xyz/url_routine_trigger/activate.php?trigger=2a27f43a-9dc0-431d-8530-8193079e2de9&token=61200b1e-2ca0-403a-9410-6a6812de14d5&response=json"
        rm -f /tmp/btn1press /tmp/btn18press
    fi
	
    # Agregar procesamiento para las otras combinaciones de botones...
done

rm -f rm -f /tmp/btn{1..20}press /tmp/exit