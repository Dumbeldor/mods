minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name();

	local formspec = ""
	
	-- worldedit_gui

		formspec = formspec
			.."size[8,6.5]"
			.."button[0,0;2,0.5;main;Back]"

			.."button_exit[0,1;2,0.5;worldedit_gui_p_set;Set Pos]"
			.."button[2,1;2,0.5;worldedit_gui_pos1;Set Pos1]"
			.."button[4,1;2,0.5;worldedit_gui_pos2;Set Pos2]"
			.."button[6,1;2,0.5;worldedit_gui_reset;Reset Pos]"

			.."button[0,2;2,0.5;worldedit_gui_volume;Volume]"
			.."button_exit[2,2;2,0.5;worldedit_gui_mark;Markers]"
			.."button[4,2;2,0.5;worldedit_gui_set;Set]"
			.."button[6,2;2,0.5;worldedit_gui_replace;Replace]"

			.."button[0,3;2,0.5;worldedit_gui_cylinder;Cylinder]"
			.."button[2,3;2,0.5;worldedit_gui_hollow_cylinder;H-Cylinder]"
			.."button[4,3;2,0.5;worldedit_gui_sphere;Sphere]"
			.."button[6,3;2,0.5;worldedit_gui_hollow_sphere;H-Sphere]"

			.."button_exit[0,4;2,0.5;worldedit_gui_dig;Dig]"
			.."button[2,4;2,0.5;worldedit_gui_copy;Copy]"
			.."button[4,4;2,0.5;worldedit_gui_move;Move]"
			.."button[6,4;2,0.5;worldedit_gui_stack;Stack]"

			.."button[0,5;2,0.5;worldedit_gui_flip;Flip]"
			.."button[2,5;2,0.5;worldedit_gui_rotate;Rotate]"
			.."button[4,5;2,0.5;worldedit_gui_transpose;Transpose]"
			.."button[6,5;2,0.5;worldedit_gui_spiral;Spiral]"
			
			.."button[0,6;2,0.5;worldedit_gui_save;Save]"
			.."button[2,6;2,0.5;worldedit_gui_load;Load]"
			.."button[4,6;2,0.5;worldedit_gui_metasave;Meta Save]"
			.."button[6,6;2,0.5;worldedit_gui_metaload;Meta Load]"
			

	
end)


