local S

if intllib then
S = intllib.Getter()
else
S = function(s) return s end
end

minetest.register_node("handmill:handmill", {
  description = S("moulin à main, actionner en tapant"),
  drawtype ="mesh",
  mesh = "handmill.obj",
  tiles = {"default_stone.png"},
  paramtypes = "light",
  paramtypes2 = "facedir",
  groups = {craky=2},
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
    meta:set_string("infotext", S("moulin à main, actionner en tapant"));
    local inv = meta:get_inventory();
    inv:set_size("seeds", 1);
    inv:set_size("flour", 4);
  end
    
})