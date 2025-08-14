/// @description Insert description here
// You can write your code in this editor
other.moveY((bbox_top-other.bbox_bottom), other.col_handler_y);
image_speed = 1;



other.spd_y = (bounce_height*other.flipped);
other.spd_x = 0;



if other.object_index = oPlayer
{
	
	other.current_state = player_states.jumping;	
	other.curr_jumps = other.max_jumps-1;
	other.curr_grav = 0;
	other.momentum_tracker.mom_y = 0;
	
}
