# 📺🎵 Reproductor de audio/video para R36S

Este proyecto permite reproducir listas **MUSICA (.m3u)** en la consola **R36S**, utilizando **mpv** y scripts personalizados para controlar las funciones mediante los botones del dispositivo.

---

## ⚙️ Instalación

1. **Copiar los scripts**
   - Copia los archivos `Musica_Play.sh`, `Musica_Play_Player.sh` y `Botones.sh` en la carpeta:
     ```
     /roms2/tools o /roms/tools (según sea el caso)
     ```

2. **Editar la ruta del playlist.m3u**
   - Abre el archivo `Musica_Play.sh` y `Musica_Play_Player.sh` reemplaza la ruta "PLAYLIST=" del playlist:
     ```bash
     PLAYLIST="/roms2/music/playlist.m3u"
     ```

3. **Instalar dependencias**
   ```bash
   sudo apt install socat
   sudo apt install mpv --no-install-recommends
   sudo apt install pulseaudio

Copiar los scripts LUA

Copia todos los archivos .lua en la carpeta:

    /home/ark/.config/mpv/scripts

Agregar tarea al inicio del sistema

    crontab -e


Agrega la siguiente línea al final:

    @reboot bash /roms2/tools/Botones.sh


o, de tener solo una MicroSD:

    @reboot basg /roms/tools/Botones.sh
    

Reinicia el dispositivo para aplicar los cambios.

##📱 Controles

	Control	Acción
	
	D-Pad Izquierdo	=	Track previo
   	D-Pad Derecho	=	Siguiente Track
   	Stick Derecho Arriba/Abajo	=	Mostrar playlist y navegar
   	Stick Derecho Izq/Der	=	Avanza/retrocede 20 tracks en la lista
   	Fn + Stick Izquierdo Abajo	=	Mostrar hora y batería restante
   	Fn + Y	=	Activar/desactivar modo aleatorio en playlist
   	Fn + A	=	Buscar nuevos archivos (/roms2/music/*), actualizar el playlist y volverlo a cargar
   	Fn + X	=	Mostrar nombre del track actual
   	Fn + B	=	Mostrar información completa del audio/video actual
    Fn + R1 = Activa/desactiva las letras de las canciones (requiere internet)
    Fn + Boton Stick izquierdo = Apaga la pantalla y desactiva botones

  Con Pantalla apagada:
  
    Fn + D-Pad Izquierdo = Track Previo
    Fn + D-Pad Derecho = Siguiente Track
    
  Controles adicionales:
  
    Fn + R2 = Apaga WiFi
    Fn + L2 = Enciende WiFi
    
	
🧩 Notas

    El script Botones.sh debe permanecer en ejecución para que los controles funcionen, este se ejecuta automáticamente al inicio del sistema (crontab)

    Se recomienda usar mpv sin dependencias adicionales para reducir el consumo de recursos.

    Algunas funciones están integradas directamente en los scripts, otras dependen de script LUA en MPV.

🖼️ Capturas de Pantalla

