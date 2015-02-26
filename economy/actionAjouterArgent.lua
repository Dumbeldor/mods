minetest.register_node(":default:sapling", {
	description = "Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles ={"default_sapling.png"},
	inventory_image = "default_sapling.png",
	wield_image = "default_sapling.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy=2,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_defaults(),
	after_place_node = function(pos, placer)
		set_money(placer:get_player_name(), argents[placer:get_player_name()].argent + 1)   
		changeMess(placer:get_player_name())     
    end,
    on_punch = function( pos, node, player )
		set_money(player:get_player_name(), argents[player:get_player_name()].argent - 1)    
		changeMess(player:get_player_name())    
    end,
})