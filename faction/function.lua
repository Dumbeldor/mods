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
            faction[nameFac] = {caract = string.sub(ligne, string.len(nameFac)+2)}
            print(string.sub(ligne, string.len(nameFac)+2))
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
            player[nomPlayer] = {faction = string.sub(ligne, string.len(nameFac)+2)}
            print(string.sub(ligne, string.len(nameFac)+2))
        until input:read(0) == nil
        io.close(input)
    else
        faction = {}
    end
end