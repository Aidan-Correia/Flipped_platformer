/// @description Insert description here
// You can write your code in this editor
event_inherited();

target = oPlayer;
target_angle = point_direction(pos_x, pos_y, target.pos_x, target.pos_y);


dir_change = true;
dir_change_countdown = 20;
alarm[0] = dir_change_countdown;

col_handler_x =squishCollision;
col_handler_y = squishCollision;
max_spd = 2.6;
accel = .05;

target_spd_x = 0;
target_spd_y = 0;

image_angle = 90;

handleCollision = function(collision_case)
{
	
	switch(collision_case)
	{
		case collision_handlers.nothing:
			break;
		case collision_handlers.squeeze:
			playDeath();
			break;
	}
}

playDeath = function()
{
	if (parent_shooter != noone)
	{
		parent_shooter.curr_state = shooter_states.idle
	}
	script_execute(playEffect,pos_x, pos_y, sMiniExplosion, flipped);
	//effect_create_layer("FX", ef_explosion,pos_x, pos_y, .001, c_maroon);
	instance_destroy(self);	
}