

minetest.register_node("tutorial:decowood", {
	description = "Deco Wood",
	light_source = 15,
	tiles = {"tutorial_decowood.png"},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	drop = "tutorial:pomme",
})

minetest.register_craft({
	output= 'tutorial:decowood 2',
	recipe = {
			{'default:wood', 'default:wood', ''},
			{'default:wood', 'default:wood', ''},
			{'', '', ''},
			}
	})

minetest.register_craft({
	type = "cooking",
	recipe = "tutorial:decowood",
	output = "default:wood",
	})

minetest.register_craft({
	type = "fuel",
	recipe = "tutorial:decowood",
	burntime = 7,
	})

minetest.register_abm({
	nodenames = {"tutorial:decowood"},
	interval = 2,
	chance = 1,
	action = function(pos)
		pos.y = pos.y + 1
		minetest.add_node(pos, {name="default:wood"})
		end,
	})

minetest.register_craftitem("tutorial:pomme", {
	description = "Pomme en or empoisonne",
	inventory_image = "pomme.png",
	one_use = minetest.item_eat(20)

	})

minetest.register_chatcommand("antigravity", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		player:set_physics_override({
			gravity = 0.1
			})
	end
	})
minetest.register_chatcommand("speed", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if param == "" then
			minetest.chat_send_player(name, "Speed par défault : 1")
			player:set_physics_override({
				speed = 1
				})
		else
			player:set_physics_override({
				speed = param
			})
		end
	end
	})

minetest.register_chatcommand("jump", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		player:set_physics_override({
			gravity = 8
			})
	end
	})

-- Show form when the /formspec command is used.
minetest.register_chatcommand("formspec", {
	func = function(name, param)
		minetest.show_formspec(name, "tutoral:form",
				"size[4,3]" ..
				"label[0,0;Hello, " .. name .. "]" ..
				"field[1,1.5;3,1;name;Name;]" ..
				"button_exit[1,2;2,1;exit;Save]")
	end
})


minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "tutorial:form" then
		-- Formname is not mymod:form,
		-- exit callback.
		return false
	end

	-- Send message to player.
	minetest.chat_send_player(player:get_player_name(), "You said: " .. fields.name .. "!")

	-- Return true to stop other minetest.register_on_player_receive_fields
	-- from receiving this submission.
	return true
end)

minetest.register_node("tutorial:rightclick", {
	description = "Rightclick me!",
	tiles = {"mint_abm.png"},
	groups = {cracky = 1},
	after_place_nodes = function(pos, placer)
		-- This function is run	when the chest node is placed.
		-- The following code sets the formspec for chest.
		-- Meta is a way of storing data onto a node.

		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[3,2]"..
				"label[1,1;This is shown on right click]")
	end
})



