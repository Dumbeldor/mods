local S
if intllib then
  S = intllib.Getter()
else
  S = function(s)
    return s
  end
end


minetest.register_node("handmill:handmill", {
  description = S("moulin a main, actionner en tapant"),
  drawtype ="mesh",
  mesh = "handmill.obj",
  tiles = {"default_stone.png"},
  paramtype = "light",
  paramtype2 = "facedir",
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
    meta:set_string("infotext", S("moulin a main, utilisation en tapant"));
    local inv = meta:get_inventory();
    inv:set_size("seeds", 1);
    inv:set_size("flour", 4);
  end,
  
  after_place_node = function(pos, placer)
    local meta = minetest.get_meta(pos);
    meta:set_string("owner", placer:get_player_name() or "");
    meta:set_string("infotext", S("Moulin a main, actionner en tapant (Prorietaire: %s)"):format(meta:get_string("owner") or ""));
    meta:set_string("formspec",
      "size[8,8]"..
      "image[0,1;1,1;farming_wheat_seed.png]"..
      "list[current_name;seeds;1,1;1,1;]"..
      "list[current_name;flour;5,1;2,2;]"..
      "label[0.5,0.5;"..S("Graines de ble:").."]"..
      "label[4,0.5;"..S("Farine:").."]"..
      "label[0,-0.2;"..S("Moulin").."]"..
      "label[2.5,-0.2;"..S("Proprietaire: %s"):format(meta:get_string('owner') or "").."]"..
      "label[0,2.5;"..S("Tapez ce moulin a main").."]"..
      "label[0,3.0;"..S("pour convertir les grains en farine.").."]"..
      "list[current_player;main;0,4;8,4;]");
    end,
  
  can_dig = function(pos,player)
    local meta = minetest.get_meta(pos);
    local inv = meta:get_inventory();
    local owner = meta:get_string('owner');

    if( not( inv:is_empty("flour")) or not( inv:is_empty("seeds")) or not( player ) or ( owner and owner ~= '' and player:get_player_name() ~= owner )) then 
      return false;
    else
      return true;
    end
  end,
    
  allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
    local meta = minetest.get_meta(pos)
    if( player and player:get_player_name() ~= meta:get_string('owner' )) then
      return 0
    else
      return count;
    end
  end,

  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    local meta = minetest.get_meta(pos)
  
    -- only accept input the threshing floor can use/process
    if( listname=='flour' or (listname=='seeds' and stack and stack:get_name() ~= 'farming:seed_wheat' )) then
      return 0;
    end
    if( player and player:get_player_name() ~= meta:get_string('owner' )) then
      return 0
    end
    return stack:get_count()
  end,

  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    local meta = minetest.get_meta(pos)
    if( player and player:get_player_name() ~= meta:get_string('owner' )) then
      return 0
    else
      return stack:get_count()
    end
  end,

  
  on_punch = function(pos, node, puncher)
    if( not( pos ) or not( node ) or not( puncher )) then
      return;
    end
    local name = puncher:get_player_name();
    local meta = minetest.get_meta(pos);
    local inv = meta:get_inventory();
    local input = inv:get_list('seeds');
    local stack1 = inv:get_stack( 'seeds', 1);
    if( ( stack1:is_empty()) or( not( stack1:is_empty()) and stack1:get_name() ~= 'farming:seed_wheat')) then
      return;
    end
    -- Tourner le moulin est un processus lent, 1 -21 Farine sont générés a chaques tours
    local anz = 1 + math.random( 0, 20 );
    -- On checke qu'il y ai toujours du blé dedans
    local found = stack1:get_count();
    
    -- ne pas moudre plus de grains que ceux présents
    if( found < anz ) then
      anz = found;
    end
    
    if( inv:room_for_item('flour','farming:flour '..tostring( anz ))) then
      inv:add_item("flour",'farming:flour '..tostring( anz ));
      inv:remove_item("seeds", 'farming:seed_wheat '..tostring( anz ));
      local anz_left = found - anz;
	if( anz_left > 0 ) then
	  minetest.chat_send_player( name, S('Vous avez moulu %s grains de ble (%s restants).'):format(anz,anz_left));
	else
	  minetest.chat_send_player( name, S('Vous avez moulu les %s dernieres graines de ble.'):format(anz));
	end
	-- Si la version de minetest est recente, on fait tourner le moulin
	if( minetest.swap_node ) then
	  node.param2 = node.param2 + 1;
	  if( node.param2 > 3 ) then
	    node.param2 = 0;
	  end
	  minetest.swap_node( pos, node );
	end
    end	
  end,

})
