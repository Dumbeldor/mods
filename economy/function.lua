function save_accounts()
    local output = io.open(homes_file, "w")
	for i, v in pairs(argents) do
            	output:write(v.argent.." "..i.."\n")
    end
    io.close(output)
end
function set_money(name, amount)
    argents[name].argent = amount
    save_accounts()
end
function get_money(name)
    return argents[name].argent
end
function exist(name)
    return argents[name] ~= nil
end
function sonsReussis(name)
	minetest.sound_play("coin", {
		to_player = name,
		gain = 2.0,
	})
end
function sonsErreur(name)
	minetest.sound_play("error", {
		to_player = name,
		gain = 2.0,
	})
end

function changeMess(pseudo)
	local player = minetest.get_player_by_name(pseudo)
	player:hud_remove(idx)
	idx = player:hud_add({
		hud_elem_type = "text",
		position = {x = 1, y = 0},
		offset = {x=-100, y = 20},
		scale = {x = 100, y = 100},
		text = "Salut " .. player:get_player_name() .. "\n" .. "Portefeuille :".. argents[player:get_player_name()].argent .. nomMoney
	})
	
end
