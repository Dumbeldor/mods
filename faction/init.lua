--Chargement du fichier ou on stock les factions
fileList= minetest.get_modpath("faction") .. "/list"
filePlayer = minetest.get_modpath("faction") .. "/player"

--Variable global
faction = {}
player = {}

--Chargement
dofile(minetest.get_modpath("faction").."/function.lua")
loadEconomy()