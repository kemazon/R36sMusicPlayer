#!/bin/bash

RUTA_MUSICA="/roms2/music"

#Cerrar instancias de reproductores
echo 'keypress q' | socat - /tmp/mpvsocket
echo 'quit' | socat - /tmp/mpvsocket
killall Musica_Play.sh
killall mpv

#bajar consumo de CPU
sudo sh -c 'echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'
sudo sh -c 'echo powersave > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor'
sudo sh -c 'echo powersave > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor'
sudo sh -c 'echo powersave > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor'
sudo sh -c 'echo 1008000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq'

mpv --ao=pulse --sub-color='#ffff01' --sub-shadow-offset=10 --sub-visibility=yes --sub-shadow-color='#0f0300' --sub-bold=yes --sub-font-size=60 --sub-pos=60 --save-position-on-quit=yes --resume-playback --fs --osd-color="#05fcba" --osd-duration=5000 --osd-font-size=40.000 --osd-level=2 --osd-italic=yes --osd-scale=1.300 --osd-shadow-color "#000000" --osd-shadow-offset=8.000 --player-operation-mode=cplayer --geometry=640x480 --autofit=640x480 --image-display-duration=inf --video-unscaled=yes --video-aspect=-1 --volume-max=100.000 --cache=no --demuxer-thread=no --hr-seek=no --vd-lavc-threads=1 --hwdec=no --really-quiet --untimed /roms2/music/playlist.m3u --input-ipc-server=/tmp/mpvsocket