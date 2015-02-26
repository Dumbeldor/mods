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