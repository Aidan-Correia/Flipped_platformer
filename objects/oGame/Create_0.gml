/// @description Insert description here
// You can write your code in this editor

global.actor_list = [];
global.dtime_constant = 1;



enum collision_handlers
{
	nothing = 0,
	squeeze = 1,
	
}


game_set_speed(60, gamespeed_fps);

instance_create_layer(x,y, "player", oCamera);


