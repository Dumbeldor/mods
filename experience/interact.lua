minetest.register_abm({
	nodenames = {"group:dirt"},
	neighbors = {"group:stone"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = "default:cobblestone"})
		afficher(active_object_count:get_player_name())
	end,
})


minetest.register_on_dignode(function(pos, oldnode, digger)
	if oldnode.name == "default:stone_with_coal" then --Si le joueur mine du charbon
		setXp(digger:get_player_name(), getXp(digger:get_player_name()) + 3)
    	afficher(digger:get_player_name())
    end
end)