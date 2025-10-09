--------------------------------------------------
-- Variables de control
--------------------------------------------------
local current_lyrics_file = nil
local lyrics_file_path = "/tmp/lyric"  -- Archivo temporal que indica el estado de las letras

local shuffle_file_path = "/tmp/shuffle"  -- Archivo temporal que indica el estado de aleatorio

--------------------------------------------------
-- Función para verificar si un archivo existe
--------------------------------------------------
local function file_exists(file_path)
    local file = io.open(file_path, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

--------------------------------------------------
-- Función para descargar las letras desde Musixmatch
--------------------------------------------------
local function download_lyrics_from_musixmatch(track_name, artist_name, dir_path)
    local musixmatch_url = "https://apic-desktop.musixmatch.com/ws/1.1/macro.subtitles.get"
    local app_id = "web-desktop-app-v1.0"
    local usertoken = "2501192ac605cc2e16b6b2c04fe43d1011a38d919fe802976084e7"
    local response_file_path = dir_path .. "musixmatch_response.txt"
    
    -- Construir el comando curl
    local curl_command = string.format(
        'curl --silent --get --cookie "x-mxm-token-guid=%s" "%s" --data "app_id=%s" --data "usertoken=%s" --data-urlencode "q_track=%s" --data-urlencode "q_artist=%s" > "%s"',
        usertoken, musixmatch_url, app_id, usertoken, track_name, artist_name, response_file_path
    )

    os.execute(curl_command)

    local response_file = io.open(response_file_path, "r")
    if response_file then
        local response = response_file:read("*a")
        response_file:close()

        mp.osd_message("Respuesta de Musixmatch guardada en musixmatch_response.txt")

        local lyrics_start = string.find(response, '"subtitle_body":"')
        if lyrics_start then
            local lyrics_end = string.find(response, '","subtitle_avg_count"')
            local lyrics = string.sub(response, lyrics_start + 17, lyrics_end - 1)
            lyrics = lyrics:gsub("\\n", "\n"):gsub('\\"', '"')

            local lrc_file = dir_path .. artist_name .. " - " .. track_name .. ".lrc"
            local file = io.open(lrc_file, "w")
            if file then
                file:write(lyrics)
                file:close()
                -- mp.osd_message("Letras descargadas y guardadas en: " .. lrc_file)
                current_lyrics_file = lrc_file

                mp.commandv("sub-add", lrc_file, "auto")
                mp.add_timeout(0.2, function()
                    os.execute("echo 'keypress j' | socat - /tmp/mpvsocket")
                    mp.osd_message("Letras descargadas de Musixmatch.")
                    mp.set_property("sub-visibility", "yes")
                end)
            else
                mp.osd_message("Error al guardar las letras.")
            end
        else
            mp.osd_message("No se encontraron letras en Musixmatch.")
        end
    else
        mp.osd_message("Error al leer el archivo de respuesta.")
    end
end

--------------------------------------------------
-- Función para cargar las letras locales
--------------------------------------------------
local function load_lyrics()
    local audio_file = mp.get_property("path")
    if not audio_file then
        mp.osd_message("No se está reproduciendo ningún archivo de audio.")
        return
    end

    local dir_path = audio_file:match("^(.*[/\\])") or "./"
    local audio_name = audio_file:match("([^/\\]+)%.%w+$")
    audio_name = audio_name:gsub("[\\/:*?\"<>|]", "_")

    local artist_name, track_name = audio_name:match("^(.-) %- (.-)$")
    if not artist_name or not track_name then
        mp.osd_message("No se pudo extraer el artista y el título de la canción.")
        return
    end

    local lrc_file = dir_path .. audio_name .. ".lrc"
    local file = io.open(lrc_file, "r")
    if file then
        file:close()
        mp.commandv("sub-add", lrc_file, "auto")
        mp.add_timeout(0.2, function()
            os.execute("echo 'keypress j' | socat - /tmp/mpvsocket")
            mp.set_property("sub-visibility", "yes")
            mp.osd_message("Letras cargadas localmente.")
        end)
        current_lyrics_file = lrc_file
    else
        mp.osd_message("No se encontró el archivo de letras localmente. Buscando en Musixmatch...")
        os.execute ("sleep 1")
        download_lyrics_from_musixmatch(track_name, artist_name, dir_path)
    end
end



--------------------------------------------------
-- Función para eliminar las letras
--------------------------------------------------
local function unload_lyrics()
    if current_lyrics_file then
        mp.set_property("sub-visibility", "no")
        mp.osd_message("Letras desactivadas.")
        current_lyrics_file = nil
    else
        mp.osd_message("No hay letras cargadas para desactivar.")
    end
end


--------------------------------------------------
-- Función para activar las letras automáticamente si el archivo temporal existe
--------------------------------------------------
local function auto_load_lyrics()
    if file_exists(lyrics_file_path) then
        load_lyrics()  -- Cargar las letras si el archivo temporal existe
        mp.set_property("sub-visibility", "yes")
    end
end

--------------------------------------------------
-- Función para alternar las letras con Alt+r
--------------------------------------------------

-- mp.osd_message("Archivo existe? " .. tostring(file_exists(lyrics_file_path)))
-- os.execute ("sleep 1")
local function toggle_lyrics()
    mp.osd_message("Verificando estado de las letras ...")

    if file_exists(lyrics_file_path) then
        mp.osd_message("...")
        -- os.execute ("sleep 2")
        local success = os.execute("rm -f " .. lyrics_file_path)
        if success then
            unload_lyrics()
            mp.osd_message("Letras desactivadas")
            -- os.execute ("sleep 1")
        else
            mp.osd_message("Error al eliminar el archivo.")
            -- os.execute ("sleep 1")
        end
    else
        mp.osd_message("...")
        -- os.execute ("sleep 2")
        local success = os.execute("touch " .. lyrics_file_path)
        if success then
            mp.osd_message("Letras activadas.")
            -- os.execute ("sleep 1")
            load_lyrics()
        else
            mp.osd_message("Error al crear el archivo.")
            -- os.execute ("sleep 1")
        end
    end
end


local function toggle_shuffle()
    mp.osd_message("Verificando shuffle ...")

    if file_exists(shuffle_file_path) then
        mp.osd_message("...")
        -- os.execute ("sleep 2")
        local success = os.execute("rm -f " .. shuffle_file_path)
        if success then
            -- os.execute("echo 'playlist-unshuffle' | socat - /tmp/mpvsocket")
            os.execute("echo 'loadfile /roms2/music/playlist.m3u' | socat - /tmp/mpvsocket")
            os.execute("sleep 0.5")
            mp.osd_message("Aleatorio desactivado")
            -- os.execute ("sleep 1")
        else
            mp.osd_message("Error al eliminar el archivo.")
            -- os.execute ("sleep 1")
        end
    else
        mp.osd_message("...")
        -- os.execute ("sleep 2")
        local success = os.execute("touch " .. shuffle_file_path)
        if success then
            os.execute("echo 'playlist-shuffle' | socat - /tmp/mpvsocket")
            mp.osd_message("Aleatorio activado.")
            -- os.execute ("sleep 1")
            -- load_lyrics()
        else
            mp.osd_message("Error al crear el archivo.")
            -- os.execute ("sleep 1")
        end
    end
end

--------------------------------------------------
-- Evento para cada nuevo track cargado
--------------------------------------------------
mp.register_event("file-loaded", function()
    auto_load_lyrics()  -- Comprobar si las letras deben cargarse al cargar un nuevo archivo
end)

--------------------------------------------------
-- Atajos de teclado
--------------------------------------------------
mp.add_key_binding("Alt+r", "toggle-lyrics", toggle_lyrics)
mp.add_key_binding("Alt+m", "toggle-shuffle", toggle_shuffle)
