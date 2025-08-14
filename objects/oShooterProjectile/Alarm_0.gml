/// @description Insert description here
// You can write your code in this editor
target_angle = point_direction(pos_x, pos_y, target.pos_x, target.pos_y);


target_spd_x = max_spd*dcos(target_angle);
target_spd_y = max_spd*dsin(target_angle)*-1;



alarm[0] = dir_change_countdown;
