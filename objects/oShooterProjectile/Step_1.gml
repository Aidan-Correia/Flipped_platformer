/// @description Insert description here
// You can write your code in this editor
/*if (dir_change)
{
	target_angle = point_direction(pos_x, pos_y, target.pos_x, target.pos_y);
	show_debug_message(target_angle);
	dir_change = false;
	alarm[0] = dir_change_countdown;
}*/

/*
target_spd_x = max_spd*dcos(target_angle);
target_spd_y = max_spd*dsin(target_angle);*/

spd_x += sign(target_spd_x - spd_x)*accel;
spd_y += sign(target_spd_y - spd_y)*accel;
image_angle = point_direction(0, 0, spd_x, spd_y);

moveSelf(spd_x, spd_y);