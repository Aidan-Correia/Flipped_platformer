/// @description Insert description here
// You can write your code in this editor


var target_speed = dir*walk_speed;

spd_x = lerp(spd_x, target_speed, .3);

spd_y -= flipped*base_grav;

moveSelf(spd_x, spd_y);
