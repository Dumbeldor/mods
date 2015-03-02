function afficher(pseudo)
	local player = minetest.get_player_by_name(pseudo)
	player:hud_remove(idx)
	idx = player:hud_add({
		hud_elem_type = "text",
		position = {x = 1, y = 0},
		offset = {x=-100, y = 50},
		scale = {x = 100, y = 100},
		number = 0xCACA00,
		text = "Vous etes lvl 100 !"
	})	
end