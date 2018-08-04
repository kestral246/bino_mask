-- bino_mask
-- kestral246@gmail.com

-- Define a global variable to maintain per player state
bino_mask = {}

-- Initialize player's global state when player joins
minetest.register_on_joinplayer(function(player)
    local pname = player:get_player_name()
    bino_mask[pname] = {mask = false, id = nil}
end)

-- Delete player's global state when player leaves
minetest.register_on_leaveplayer(function(player)
    local pname = player:get_player_name()
    if bino_mask[pname] then
        bino_mask[pname] = nil
    end
end)

minetest.register_globalstep(function(dtime)
    local players = minetest.get_connected_players()
    for i,player in ipairs(players) do
        local pname = player:get_player_name()
        local screen_w = minetest.settings:get("screen_w") or 1600
        local screen_h = minetest.settings:get("screen_h") or 900
        local aspect = screen_w / screen_h
        local xscale = 0
        local yscale = 0
        local xpos = 0
        local ypos = 0
        if aspect >= 2 then
            xscale = 1
            yscale = aspect
            xpos = 0
            ypos = -(yscale/2 - 0.5)
        elseif aspect <= 0.5 then
            xscale = 1/aspect
            yscale = 1
            xpos = -((xscale/2) - 0.5)
            ypos = 0
        elseif aspect >= 1 then
            xscale = 2/aspect
            yscale = 2
            xpos = -((xscale/2) - 0.5)
            ypos = -0.5
        else
            xscale = 2
            yscale = 2*aspect
            xpos = -0.5
            ypos = -((yscale/2) - 0.5)
        end
    
        -- minetest.chat_send_player(pname, 'aspect='..aspect..', scale='..xscale..', '..yscale..', pos='..xpos..', '..ypos)
        
        if player:get_player_control().zoom and player:get_properties().zoom_fov ~= 0 then  -- zoom key pressed and have zoom ability
            if not bino_mask[pname].mask then
                bino_mask[pname].id = player:hud_add({
                    hud_elem_type = "image",
                    text = "bino-1k.png",
                    position = {x=xpos, y=ypos},
                    scale = {x=xscale*-100, y=yscale*-100},
                    alignment = {x=1, y=1},
                    offset = {x=0, y=0}
                })
                bino_mask[pname].mask = true
            end
        else  -- zoom key not pressed
            if bino_mask[pname].mask then
                player:hud_remove(bino_mask[pname].id)
                bino_mask[pname].mask = false
            end
        end
    end  -- for
end)
