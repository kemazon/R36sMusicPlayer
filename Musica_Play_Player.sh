#!/bin/bash

RUTA_MUSICA="/roms2/music"
PLAYLIST="/roms2/music/playlist.m3u"
#Cerrar instancias de reproductores
#echo 'keypress q' | socat - /tmp/mpvsocket
#echo '{ "command": ["keypress", "q"] }' | socat - /tmp/mpvsocket
echo 'quit' | socat - /tmp/mpvsocket
killall Musica_Play_Player.sh
killall mpv

### Verifica si el script se está ejecutando como el usuario "ark"
if [ "$(whoami)" != "ark" ]; then
    echo "Este script debe ejecutarse como el usuario 'ark'."
    exit 1
fi
password="ark"
echo "$password" | su - ark -c "sleep 86400 & "
mpv --ao=pulse --no-terminal --no-border --no-osd-bar --vo=null --save-position-on-quit=yes --resume-playback --input-ipc-server=/tmp/mpvsocket $PLAYLIST & 
echo "Reproduciendo: $(basename "$file")"
#SDL_AUDIODRIVER="pulseaudio" AUDIODEV="hw:1" ffplay -autoexit -nodisp "$file" --input-ipc-server=/tmp/mpvsocket
