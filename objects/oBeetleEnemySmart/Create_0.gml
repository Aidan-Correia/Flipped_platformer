/// @description Insert description here
// You can write your code in this editor

event_inherited();

dir = -1;
walk_spd = 2.4;

beetle_grav = .25;

sub_room_belonging = 0;

idle_step_timer = 0;
idle_dir = 0;
flipped = -1;

y_col = 3;

col_handler_x = nullCollision;
col_handler_y  = waddleCollisionY;

handleCollision = function(collision_case)
{
	switch(collision_case)
	{
		case collision_handlers.nothing:
			break;
		case collision_handlers.squeeze:
			playDeath();
			break;
		case y_col:
			spd_y = 0;
			break;
	
	}
}






