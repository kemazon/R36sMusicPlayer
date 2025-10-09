-- playlistselector-window.lua
-- Playlist selector ligero con ventana desplazable (R36S)
local mp = require 'mp'
local playlist = {}
local pos = 0          -- ítem en reproducción
local selected = 0     -- ítem resaltado con ↑/↓
local jump_size = 20   -- cantidad de items a saltar con LEFT/RIGHT

-- Refrescar info de playlist
local function update_playlist()
    playlist = mp.get_property_native("playlist") or {}
    pos = mp.get_property_number("playlist-pos", 0) or 0
    if selected >= #playlist then
        selected = #playlist - 1
    end
end

-- Mostrar 5 ítems alrededor del seleccionado
local function show_window()
    update_playlist()
    if #playlist == 0 then
        mp.osd_message("Playlist vacía", 2)
        return
    end

    -- Guardar y desactivar OSD de progreso y forzar alineación izquierda
    local old_progress = mp.get_property_native("show-progress")
    local old_align = mp.get_property("osd-align-x")
    mp.set_property_native("show-progress", false)
    mp.set_property("osd-align-x", "left")

    -- Construir texto alineado a la izquierda
    local start_i = math.max(0, selected - 4)
    local end_i   = math.min(#playlist - 1, selected + 4)
    local text = "== Lista de reproducción (" .. (selected+1) .. "/" .. #playlist .. ") ==\n"
    for i = start_i, end_i do
        local line_prefix = ""
        local symbol = ""
        local name = playlist[i+1].title or playlist[i+1].filename:match("([^/\\]+)$")

        if i == pos then
            symbol = "➤ "  -- track en reproducción
        elseif i == selected then
            symbol = "→ "  -- item seleccionado
        end

        text = text .. line_prefix .. symbol .. "[" .. (i+1) .. "] " .. name .. "\n"
    end

    -- Mostrar OSD de playlist
    mp.osd_message(text, 5)

    -- Restaurar show-progress y alineación después de 10 segundos
    mp.add_timeout(10, function()
        mp.set_property_native("show-progress", old_progress)
        mp.set_property("osd-align-x", old_align or "center")
    end)
end

-- Navegación fina
local function move_up()
    if selected > 0 then
        selected = selected - 1
        show_window()
    end
end

local function move_down()
    if selected < #playlist - 1 then
        selected = selected + 1
        show_window()
    end
end

-- Navegación rápida (LEFT/RIGHT)
local function move_up_fast()
    if selected > 0 then
        selected = math.max(0, selected - jump_size)
        show_window()
    end
end

local function move_down_fast()
    if selected < #playlist - 1 then
        selected = math.min(#playlist - 1, selected + jump_size)
        show_window()
    end
end

-- Reproducir selección
local function play_selected()
    if #playlist == 0 then return end
    mp.set_property_number("playlist-pos", selected)
    pos = selected
    show_window()
end

-- Key bindings
mp.add_key_binding("p", "pl-show", show_window)         -- mostrar lista
mp.add_key_binding("UP", "pl-up", move_up)             -- subir uno
mp.add_key_binding("DOWN", "pl-down", move_down)       -- bajar uno
mp.add_key_binding("LEFT", "pl-up-fast", move_up_fast) -- salto atrás 20
mp.add_key_binding("RIGHT", "pl-down-fast", move_down_fast) -- salto adelante 20
mp.add_key_binding("ENTER", "pl-play", play_selected)  -- reproducir

mp.msg.info("Playlist Selector final cargado (ventana, símbolos, avance rápido y OSD alineado a la izquierda)")
