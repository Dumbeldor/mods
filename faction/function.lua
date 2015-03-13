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

function loadFaction()
	local input = io.open(fileList, "r")
	if input then
		repeat
		local ligne = input:read("*l")
		local list = explode(" ", ligne)
		if list[1] == nil then
			break
		end
		local nameFac = list[1]
		faction[nameFac] = {chef = list[2], description = list[3]}
		until input:read(0) == nil
		io.close(input)
	else
		faction = {}
	end

	input = io.open(filePlayer, "r")
	if input then
		repeat
		ligne = input:read("*l")
		list = explode(" ", ligne)
		if list[1] == nil then
			break
		end
		local nomPlayer = list[1]
		player[nomPlayer] = {faction = list[2], grade = list[3]}
		until input:read(0) == nil
		io.close(input)
	else
		player = {}
	end
end

function existPlayer(name)
	return player[name] ~= nil
end
function existFac(name)
	return faction[name] ~= nil
end

function setPlayer(name, fac, grade)
	if existFac(name) then	
		player[name].faction = fac
		player[name].grade = grade
	end
end

function getFacByPlayer(name)
	return player[name].faction
end	

function sonsJoinFac(name)
	minetest.sound_play("join", {
		to_player = name,
		gain = 2.0,
	})
end
function sonsLeaveFac(name)
	minetest.sound_play("leave", {
		to_player = name,
		gain = 2.0,
	})
end
