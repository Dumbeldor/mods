function save_accounts()
    local output = io.open(homes_file, "w")
	for i, v in pairs(argents) do
            	output:write(v.argent.." "..i.."\n")
    end
    io.close(output)
end
function init_money(name, amount)
	argents[name] = {argent = amount}
	save_accounts()
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
	local idx = player:hud_add({
		hud_elem_type = "text",
		position = {x = 1, y = 0},
		offset = {x=-100, y = 20},
		scale = {x = 100, y = 100},
		number = 0xCACA00,
		text = "Salut " .. player:get_player_name() .. "\n" .. "Portefeuille :".. argents[player:get_player_name()].argent .. nomMoney
	})	
end

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
