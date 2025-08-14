/// @description Insert description here
// You can write your code in this editor
event_inherited();

distance = 0;
target_spd = 1.5;
spd_x = 0;
spd_y = 0;
grav = 0;
collidable = false

if flipped
{
	image_yscale = -1
	curr_shader = invertColor
}
else
{
	image_xscale = 1
	curr_shader = defaultShader
}