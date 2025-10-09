function show_track()
    local artist = mp.get_property("metadata/by-key/artist")
    local title = mp.get_property("media-title")

    -- Si no hay artista, solo muestra el t�tulo
    if artist == nil then
        artist = ""
    end
    if title == nil then
        title = "Sin t�tulo"
    end

    local full_title = artist .. " - " .. title

    print("MPV Lua: Reproduciendo - " .. full_title)  -- Mensaje en terminal
    mp.osd_message(full_title, 5)  -- Muestra el mensaje en la pantalla por 5 segundos
end

mp.register_event("file-loaded", show_track)
