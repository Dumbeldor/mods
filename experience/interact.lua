minetest.register_abm({
	nodenames = {"group:dirt"},
	neighbors = {"group:stone"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = "default:cobblestone"})
	end,
})