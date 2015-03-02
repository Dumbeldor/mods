minetest.register_on_newplayer(function(player)
	initXp(player:get_player_name())
	afficher(player:get_player_name())
end)

minetest.register_on_joinplayer(function(player)
	if experience[player:get_player_name()] then
		afficher(player:get_player_name())
	else
		initXp(player:get_player_name())
		afficher(player:get_player_name())
	end
end)