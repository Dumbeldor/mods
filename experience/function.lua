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

--Chargement de l'xp
function loadExperience()
    local input = io.open(homes_file, "r")
    if input then
		repeat
			local ligne = input:read("*l")
            local list = explode(" ", ligne)
            if list[1] == nil then
            	break
            end
            local pseudo = list[2]
            experience[pseudo] = {xp = list[1]}
            print(string.sub(ligne, list[1]))
        until input:read(0) == nil
        io.close(input)
    else
        experience = {}
    end
end

function saveXp()
  local output = io.open(homes_file, "w")
  for i, v in pairs(experience) do
    output:write(v.xp.." "..i.."\n")
  end
  io.close(output)
end

function initXp(pseudo)
  experience[pseudo] = {xp = 0}
  saveXp()
end

function setXp(pseudo, amount)
  experience[pseudo].xp = amount
end

function getXp(pseudo)
  return experience[pseudo].xp
end

function exist(pseudo)
  return experience[pseudo] ~= nil
end
