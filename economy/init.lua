homes_file = minetest.get_worldpath() .. "/economy"

argents = {}
nomMoney = " Francs"
argentBase=200

--Chargé les functions 


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


function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1))
    pos = sp + 1 
  end
  table.insert(arr,string.sub(str,pos)) 
  return arr
end


loadEconomy()

dofile(minetest.get_modpath("economy").."/function.lua")

dofile(minetest.get_modpath("economy").."/actionAjouterArgent.lua")

minetest.register_on_newplayer(function(player)
	init_money(player:get_player_name(), 200)
	init(player:get_player_name())
end)

minetest.register_on_joinplayer(function(player)
	if argents[player:get_player_name()] then
		init(player:get_player_name())
	else
		init_money(player:get_player_name(), 200)
		init(player:get_player_name())
	end
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
				if tonumber(param[2]) then
					argents[player:get_player_name()].argent = argents[player:get_player_name()].argent - param[2];
					if argents[player:get_player_name()].argent >= 0 then
						if argents[param[1]] then
							argents[param[1]].argent = argents[param[1]].argent + param[2];
							minetest.chat_send_player(name, "Vous avez paye : " .. param[2] .. nomMoney .. " a " .. param[1])
							minetest.chat_send_player(param[1], name .. " vous a paye ".. param[2] .. nomMoney )
							sonsReussis(player:get_player_name())
							sonsReussis(param[1])
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
            				sonsErreur(name)
            			end
            		else
            			argents[player:get_player_name()].argent = argents[player:get_player_name()].argent + param[2];
            			minetest.chat_send_player(name, "Vous n'avez pas assez d'argent ! \n Votre argent : " .. argents[player:get_player_name()].argent .. nomMoney)
            			sonsErreur(name)
            		end
            	else
            		minetest.chat_send_player(name, "La somme doit etre un nombre ! \n Usage : /pay nomDuJoueur Somme")
            		sonsErreur(name)
            	end
            end
		end

    end,
})

--[[
	Création des blocks !
...]]

--[[ 

minetest.register_craftitem("economy:pences", {
	description = "Minetoon pence",
	inventory_image = "goldcoin.png",
})
-- Shilling equals 1/9 pounds, 9 pence or 1/81 gold ingot
minetest.register_craftitem("economy:shillings", {
	description = "Minetoon shilling",
	inventory_image = "9goldcoin.png",
})
-- Pound equals 1/9 gold ingot, 9 shilling or 81 pence)
minetest.register_craftitem("economy:pounds", {
	description = "Minetoon pounds",
	inventory_image = "81goldcoin.png",
})

...]]



minetest.register_node("economy:boutique", {
	description = "Utiliser pour vendre des objets",
	tiles = {
		"iron.png",
		"iron.png",
		"buy.png",
		"buy.png",
		"buy.png",
		"buy.png"
		},
	groups = {cracky = 1},
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
        meta:set_string("owner", placer:get_player_name())
        meta:set_string("infotext", "Shop (owned par " .. placer:get_player_name() .. ")")
    end,

on_construct = function(pos)
        local meta = minetest.env:get_meta(pos)
        local inv = meta:get_inventory()
         meta:set_string("formspec", "size[8,8]"..
                "field[0.256,0.5;8,1;shopname;Le nom de votre shop :;${shopname}]"..
                "field[0.256,1.5;8,1;action;Vous voulez acheter(A), vendre(V) ou acheter et vendre(AV) :;${action}]"..
                "field[0.256,2.5;8,1;amount;Par combien vous voulez acheter :;${amount}]"..
                "field[0.256,3.5;8,1;costbuy;Le montant d'achat:;${costbuy}]"..
                "field[0.256,4.5;8,1;costsell;Le montant de vente :;${costsell}]"..
                "label[0,5;Item/Bloc a vendre :]"..
                "list[context;main;0,5.5;1,1;]"..
                "button[3,5.5.5;2,1;button;Valider]"..
                "list[current_player;main;0,7.5;8,1;]") 
        meta:set_string("infotext", "Boutique fermee")
        meta:set_string("owner", "")
        local inv = meta:get_inventory()
        inv:set_size("main", 8*4)
        meta:set_string("form", "yes")
end,

--retune
    after_destruct = function(pos, oldnode)
    	minetest.remove_node(pos)
    	return 0
    end,

    on_punch = function( pos, node, player )
    -- Shop buys at costbuy
    -- Shop sells at costsell
        local meta = minetest.env:get_meta(pos)
        local inv = meta:get_inventory()
        --~ minetest.chat_send_all("Shop punched.")
        --~ minetest.chat_send_all(name)

        if player:get_player_name() == meta:get_string("owner") then
            meta:set_string("formspec", "size[8,8]"..
                "field[0.256,0.5;8,1;shopname;Le nom de votre shop :;${shopname}]"..
                "field[0.256,1.5;8,1;action;Vous voulez acheter(A), vendre(V) ou acheter et vendre(AV) :;${action}]"..
                "field[0.256,2.5;8,1;amount;Par combien vous voulez acheter :;${amount}]"..
                "field[0.256,3.5;8,1;costbuy;Le montant d'achat:;${costbuy}]"..
                "field[0.256,4.5;8,1;costsell;Le montant de vente :;${costsell}]"..
                "label[0,5;Item/Bloc a vendre :]"..
                "list[context;main;0,5.5;1,1;]"..
                "button[3,5.5.5;2,1;button;Valider]"..
                "list[current_player;main;0,7.5;8,1;]")           

            meta:set_string("infotext", "Boutique fermee")
            meta:set_string("form", "yes")
        end
    end,



    can_dig = function(pos,player)
        local meta = minetest.env:get_meta(pos);
        local inv = meta:get_inventory()
        return inv:is_empty("main") and (meta:get_string("owner") == player:get_player_name() or minetest.get_player_privs(player:get_player_name())["money_admin"])
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.env:get_meta(pos)
        if not (player:get_player_name() == meta:get_string("owner")) then
            minetest.log("action", player:get_player_name()..
                    " tried to access a shop belonging to "..
                    meta:get_string("owner").." at "..
                    minetest.pos_to_string(pos))
           return 0
        end
        return count
    end,


    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.env:get_meta(pos)
       if not (player:get_player_name() == meta:get_string("owner")) then
            minetest.log("action", player:get_player_name()..
                    " tried to access a shop belonging to "..
                    meta:get_string("owner").." at "..
                    minetest.pos_to_string(pos))
           return 0
        end
        return stack:get_count()
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.env:get_meta(pos)

       if not (player:get_player_name() == meta:get_string("owner")) then
            minetest.log("action", player:get_player_name()..
                    " tried to access a shop belonging to "..
                    meta:get_string("owner").." at "..
                    minetest.pos_to_string(pos))
           return 0
        end
        return stack:get_count()
    end,

    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff in shop at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name()..
                " moves stuff to shop at "..minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, count, player)
        minetest.log("action", player:get_player_name()..																
                " takes stuff from shop at "..minetest.pos_to_string(pos))
    end,

    on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos)  
        local inv = meta:get_inventory()
        local blocDansInv = inv:get_list("main")
        local blocName = explode(" ", blocDansInv[1]:to_string())
        if not (blocDansInv[1]:to_string() ~= "") then
        	if not(meta:get_string("form") == "yes") then
        		minetest.chat_send_player(sender:get_player_name(), "Il n'y a plus rien dans la boutique, contacter le gérant de cette boutique pour avoir plus de renseignement : " .. meta:get_string("owner") .. ".")
        		minetest.chat_send_player(meta:get_string("owner"), sender:get_player_name() .. " a essaye d'acheter dans votre boutique mais il semblerait qu'elle soit vide...")
        		sonsErreur(sender:get_player_name())
        		sonsErreur(meta:get_string("owner"))
        	end
        else          
        	if meta:get_string("form") == "yes" then
        		-- (meta:get_string("owner") == sender:get_player_name() or minetest.get_player_privs(sender:get_player_name())["money_admin"])
            	if fields.shopname ~= "" and (fields.action == "A" or fields.action == "V" or fields.action == "AV") and tonumber(fields.amount) and tonumber(fields.amount) >= 1 and meta:get_string("owner") == sender:get_player_name() then
                	if fields.action == "A" then
                   	 	if not tonumber(fields.costbuy) then
                        	return
                   	 	end
                   	 	if not (tonumber(fields.costbuy) >= 0) then
                        	return
                    	end
                	end
                	if fields.action == "V" then
                    	if not tonumber(fields.costsell) then
                        	return
                    	end
                    	if not (tonumber(fields.costsell) >= 0) then
                        	return
                    	end
                	end
                	if fields.action == "AV" then
                    	if not tonumber(fields.costbuy) then
                        	return
                    	end
                    	if not (tonumber(fields.costbuy) >= 0) then
                        	return
                    	end
                    	if not tonumber(fields.costsell) then
                        	return
                    	end
                    	if not (tonumber(fields.costsell) >= 0) then
                        	return
                    	end
                	end
                	local s, ss
                	if fields.action == "A" then
                	-- Shop buys, player sells: at costbuy
                    	s = " vendre "
                    	ss = "button[1,5;2,1;buttonsell;Vendre("..fields.costbuy..")]"
                	elseif fields.action == "V" then
                	-- Shop sells, player buys: at costsell
                    	s = " acheter "
                    	ss = "button[1,5;2,1;buttonbuy;Acheter("..fields.costsell..")]"
               	 	else
                    	s = " vendre et acheter "
                    	ss = "button[1,5;2,1;buttonbuy;Acheter("..fields.costsell..")]" .. "button[5,5;2,1;buttonsell;Vendre("..fields.costbuy..")]"
                	end
                	local meta = minetest.env:get_meta(pos)
                	meta:set_string("formspec", "size[8,10;]"..
                    	"list[context;main;0,0;8,4;]"..
                    	"label[0.256,4.5;Vous pouvez "..s..fields.amount.." "..blocName[1].."]"..
                    	ss..
                    	"list[current_player;main;0,6;8,4;]")
                	meta:set_string("shopname", fields.shopname)
                	meta:set_string("action", fields.action)
                	meta:set_string("nodename", fields.nodename)
                	meta:set_string("amount", fields.amount)
                	meta:set_string("costbuy", fields.costbuy)
                	meta:set_string("costsell", fields.costsell)
               	 	meta:set_string("infotext", "Shop \"" .. fields.shopname .. "\" (owned par " .. meta:get_string("owner") .. ")")
                	meta:set_string("form", "no")
            	end
        	elseif fields["buttonbuy"] then
        	-- Shop sells, player buys: at costsell: with buttonbuy
            	local sender_name = sender:get_player_name()
            	local inv = meta:get_inventory()
            	local sender_inv = sender:get_inventory()
            	if not inv:contains_item("main", blocName[1] .. " " .. meta:get_string("amount")) then 
                	minetest.chat_send_player(sender_name, "Il n'y a pas assez de marchandise dans la boutique !")
                	sonsErreur(sender_name)
                	return true
           	 	elseif not sender_inv:room_for_item("main", blocName[1] .. " " .. meta:get_string("amount")) then
                	minetest.chat_send_player(sender_name, "Votre inventaire est plein !")
                	sonsErreur(sender_name)
                	return true
            	elseif get_money(sender_name) - tonumber(meta:get_string("costsell")) < 0 then
                	minetest.chat_send_player(sender_name, "Vous n'avez pas assez d'argent...")
                	sonsErreur(sender_name)
                	return true
            	elseif not exist(meta:get_string("owner")) then
                	minetest.chat_send_player(sender_name, "Le compte du proprietaire du shop n'existe pas... Essayez plus tard ou/et contactez un Administrateur !")
                	sonsErreur(sender_name)
                	return true
            	end
            	set_money(sender_name, get_money(sender_name) - meta:get_string("costsell"))
            	set_money(meta:get_string("owner"), get_money(meta:get_string("owner")) + meta:get_string("costsell"))
            	sender_inv:add_item("main", blocName[1] .. " " .. meta:get_string("amount"))
            	inv:remove_item("main", blocName[1] .. " " .. meta:get_string("amount"))
            	minetest.chat_send_player(sender_name, "Vous avez achete " .. meta:get_string("amount") .. " " .. blocName[1] .. " pour " .. meta:get_string("costsell") .. " " .. nomMoney.. ".")
            	minetest.chat_send_player(meta:get_string("owner"), sender_name .. " vous a achete " .. meta:get_string("amount") .. " " .. blocName[1] .. " pour " .. meta:get_string("costsell") .. " " .. nomMoney .. ".")
            	sonsReussis(sender_name)
            	sonsReussis(meta:get_string("owner"))
            	changeMess(sender_name)	
						for _,player in ipairs(minetest.get_connected_players()) do
							local name = player:get_player_name()
							if name == meta:get_string("owner") then
								changeMess(name)
							end
						end
        	elseif fields["buttonsell"] then
            	-- Shop buys, player sells: at costbuy: with buttonsell
            	local sender_name = sender:get_player_name()
            	local inv = meta:get_inventory()
            	local sender_inv = sender:get_inventory()
            	if not sender_inv:contains_item("main", blocName[1] .. " " .. meta:get_string("amount")) then
                	minetest.chat_send_player(sender_name, "Vous n'avez pas assez de produit !")
    	            sonsErreur(sender_name)
                return true
        	    elseif not inv:room_for_item("main", blocName[1] .. " " .. meta:get_string("amount")) then
            	    minetest.chat_send_player(sender_name, "Il n'y a pas assez de place dans le shop, contactez le proprietaire pour qu'il le vide.")
                	sonsErreur(sender_name)
                return true
	            elseif get_money(meta:get_string("owner")) - meta:get_string("costbuy") < 0 then
	                minetest.chat_send_player(sender_name, "L'acheteur n'a pas assez d'argent.")
    	            sonsErreur(sender_name)
        	        return true
	            elseif not exist(meta:get_string("owner")) then
    	            minetest.chat_send_player(sender_name, "Le compte du proprietaire du shop n'existe pas... Essayez plus tard ou/et contactez un Administrateur !")
        	        sonsErreur(sender_name)
            	    return true
	            end
    	        set_money(sender_name, get_money(sender_name) + meta:get_string("costbuy"))
        	    set_money(meta:get_string("owner"), get_money(meta:get_string("owner")) - meta:get_string("costbuy"))
            	sender_inv:remove_item("main", blocName[1] .. " " .. meta:get_string("amount"))
	            inv:add_item("main", blocName[1] .. " " .. meta:get_string("amount"))
    	        minetest.chat_send_player(sender_name, "Vous avez vendu " .. meta:get_string("amount") .. " " .. blocName[1] .. " pour " .. meta:get_string("costbuy") .. " " .. nomMoney .. ".")
        	    minetest.chat_send_player(meta:get_string("owner"), sender_name .. " vous a vendu " .. meta:get_string("amount") .. " " .. blocName[1] .. " pour " .. meta:get_string("costbuy") .. " " .. nomMoney .. ".")
	            sonsReussis(sender_name)
    	        sonsReussis(meta:get_string("owner"))
        	    changeMess(sender_name)	
						for _,player in ipairs(minetest.get_connected_players()) do
							local name = player:get_player_name()
							if name == meta:get_string("owner") then
								changeMess(name)
							end
						end
        	end
        end
    end,

--end retune

   
 })

minetest.register_node("economy:blocFerRenforce", {
	tiles = {"iron.png"},
	groups = {cracky = 1},
})



minetest.register_craft({
	output = "economy:blocFerRenforce 1",
	recipe = {
	{'default:steelblock', 'default:steelblock', 'default:steelblock'},
	{'default:steelblock', 'default:diamond', 'default:steelblock'},
	{'default:steelblock', 'default:steelblock', 'default:steelblock'},
}
})

minetest.register_craft({
	output = "economy:buy 1",
	recipe = {
	{'economy:blocFerRenforce', 'economy:blocFerRenforce', 'economy:blocFerRenforce'},
	{'economy:blocFerRenforce', 'default:diamond', 'economy:blocFerRenforce'},
	{'economy:blocFerRenforce', 'economy:blocFerRenforce', 'economy:blocFerRenforce'},
}
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



--[[
Gestion interaction avec blocks
...]]

