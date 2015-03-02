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

function loadExperience()
    local input = io.open(homes_file, "r")
    if input then
		repeat
			local ligne = input:read("*l")
            local list = explode(" ", ligne)
            if list[1] == nil then
            	break
            end
            local pseudo = list[1]
            faction[pseudo] = {xp = string.sub(ligne, string.len(pseudo)+2)}
            print(string.sub(ligne, string.len(pseudo)+2))
        until input:read(0) == nil
        io.close(input)
    else
        faction = {}
    end
end