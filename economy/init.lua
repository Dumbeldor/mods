local homes_file = minetest.get_worldpath() .. "/economy"
argents = {}
local nomMoney = " Francs"
local argentBase=200
local idx

local function loadEconomy()
    local input = io.open(homes_file, "r")
    if input then
		repeat
            local x = input:read("*n")
            if x == nil then
            	break
            end
            local name = input:read("*l")
            argents[name:sub(2)] = {argent = x}
        until input:read(0) == nil
        io.close(input)
    else
        argents = {}
    end
end

local function changeMess(pseudo)
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


function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end


loadEconomy()


minetest.register_on_joinplayer(function(player)
	changeMess(player:get_player_name())
end)

minetest.register_on_newplayer(function(player)
	minetest.chat_send_player(player:get_player_name(), "Bienvenue vous avez " .. argentBase .. nomMoney .. " de base !")
	argents[player:get_player_name()] = {argent = argentBase}
	local output = io.open(homes_file, "w")
	for i, v in pairs(argents) do
             output:write(v.argent.." "..i.."\n")
          end
          io.close(output)

    idx = player:hud_add({
		hud_elem_type = "text",
		position = {x = 1, y = 0},
		offset = {x=-100, y = 20},
		scale = {x = 100, y = 100},
		text = "Bienvenue " .. player:get_player_name() .. "\n" .. "Portefeuille ".. argents[player:get_player_name()].argent .. nomMoney
	})
end)



minetest.register_chatcommand("money", {
    description = "Affiche l'argent du joueur",
    
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player == nil then
            return false
        end
        if argents[player:get_player_name()] then
        	changeMess(player:get_player_name())            
            minetest.chat_send_player(name, "Vous avez : " .. argents[player:get_player_name()].argent .. nomMoney)
        else
            minetest.chat_send_player(name, "Vous n'avez pas encore d'argent..." )
        end
    end,
})

minetest.register_chatcommand("pay", {
    description = "Paye un joueur",
    
    func = function(name, params)
        local player = minetest.get_player_by_name(name)
        param = explode(" ", params)
		if param[1] == nil then
			minetest.chat_send_player(name, "Vous devez preciser a quoi vous voulez envoyer l'argent ! \n Usage : /pay nomDuJoueur Somme")
		elseif param[2] == nil then
			minetest.chat_send_player(name, "Vous devez preciser a quoi vous voulez envoyer l'argent ! \n Usage : /pay nomDuJoueur Somme")
		else

			if argents[player:get_player_name()] then
				argents[player:get_player_name()].argent = argents[player:get_player_name()].argent - param[2];
				if argents[player:get_player_name()].argent > 0 then
					if argents[param[1]] then
						argents[param[1]].argent = argents[param[1]].argent + param[2];
						minetest.chat_send_player(name, "Vous avez paye : " .. param[2] .. nomMoney .. " a " .. param[1])
						minetest.chat_send_player(param[1], name .. " vous a paye ".. param[2] .. nomMoney )
						minetest.sound_play("mint_coin", {
							to_player = player:get_player_name(),
							gain = 2.0,
						})
						minetest.sound_play("mint_coin", {
							to_player = param[1],
							gain = 2.0,
						})
						changeMess(player:get_player_name())	
						for _,player in ipairs(minetest.get_connected_players()) do
							local name = player:get_player_name()
							if name == param[1] then
								changeMess(name)
							end
						end

						local output = io.open(homes_file, "w")
						for i, v in pairs(argents) do
                		output:write(v.argent.." "..i.."\n")
            			end
            			io.close(output)
            		else
            			minetest.chat_send_player(name, "Le joueur n'existe pas !")
            		end
            	else
            		argents[player:get_player_name()].argent = argents[player:get_player_name()].argent + param[2];
            		minetest.chat_send_player(name, "Vous n'avez pas assez d'argent ! \n Votre argent : " .. argents[player:get_player_name()].argent .. nomMoney)
            	end
            end
		end

    end,
})

minetest.register_craftitem("economy:pences", {
	description = "Minetoon pence",
	inventory_image = "mint_goldcoin.png",
})
-- Shilling equals 1/9 pounds, 9 pence or 1/81 gold ingot
minetest.register_craftitem("economy:shillings", {
	description = "Minetoon shilling",
	inventory_image = "mint_9goldcoin.png",
})
-- Pound equals 1/9 gold ingot, 9 shilling or 81 pence)
minetest.register_craftitem("economy:pounds", {
	description = "Minetoon pounds",
	inventory_image = "mint_81goldcoin.png",
})


minetest.register_craft({
	output= 'economy:shillings 1',
	recipe = {
			{'economy:pences', 'economy:pences', 'economy:pences'},
			{'economy:pences', 'economy:pences', 'economy:pences'},
			{'economy:pences', 'economy:pences', 'economy:pences'},
			}
	})
minetest.register_craft({
	output= 'economy:pounds 1',
	recipe = {
			{'economy:shillings', 'economy:shillings', 'economy:shillings'},
			{'economy:shillings', 'economy:shillings', 'economy:shillings'},
			{'economy:shillings', 'economy:shillings', 'economy:shillings'},
			}
	})
minetest.register_craft({
	output= 'economy:shillings 1',
	recipe = { 
			{ 'economy:pounds' }
			}
	})
minetest.register_craft({
	output= 'economy:pences 1',
	recipe = { 
			{ 'economy:shillings' }
			}
	})


