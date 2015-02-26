local S

if intllib then
S = intllib.Getter()
else
S = function(s) return s end
end

minetest.register_craft({
        output = "handmill:handmill",
        recipe = {
                {"default:stick",     "default:stone",    "", },
                {"",               "default:steel_ingot", "", },
                {"",                  "default:stone",    "", },
        },
})

minetest.register_node("handmill:handmill", {
  description = S("moulin à main, actionner en tapant"),
  drawtype ="mesh",
  mesh = "handmill.obj",
  tiles = {"default_stone.png"},
  paramtype = "light",
  paramtypes2 = "facedir",
  groups = {cracky=2},
  is_ground_content = false,
  
  select_box = {
    type = "fixed",
    fixed = {
      {-0.50, -0.5,-0.50, 0.50, 0.25, 0.50},
    }
  },
  
  colision_box = {
    type = "fixed",
    fixed = {
      {-0.50, -0.5,-0.50, 0.50, 0.25, 0.50},
    }
  },
  
  on_construct = function(pos)
    local meta = minetest.get_meta(pos);
    meta:set_string("infotext", S("moulin à main, utilisation en tapant"));
    local inv = meta:get_inventory();
    inv:set_size("seeds", 1);
    inv:set_size("flour", 4);
  end,
  
  after_place_node = function(pos, placer)
    local meta = minetest.get_meta(pos);
    meta:set_string("proprio", placer:get_player_name() or "");
    meta:set_string("infotext", S("Moulin à main, actionner en tapant (possédé par %s)"):format(meta:get_string("proprio") or ""));
    meta:set_string("formspec",
      "size[8,8]"..
      "image[0,1;1,1;farming_wheat_seed.png]"..
      "list[current_name;seeds;1,1;1,1;]"..
      "list[current_name;flour;5,1;2,2;]"..
      "label[0.5,0.5;"..S("Graines de blé:").."]"..
      "label[4,0.5;"..S("Farine:").."]"..
      "label[0,-0.2;"..S("Moulin").."]"..
      "label[2.5,-0.2;"..S("Propriétaire: %s"):format(meta:get_string('proprio') or "").."]"..
      "label[0,2.5;"..S("Tape ce moulin à main").."]"..
      "label[0,3.0;"..S("pour convertir les grains en farine.").."]"..
      "list[current_player;main;0,4;8,4;]");
    end,
  
})
