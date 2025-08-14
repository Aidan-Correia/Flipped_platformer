/// @description Insert description here
// You can write your code in this editor

cam = view_camera[0];

cam_width = camera_get_view_width(cam);
cam_height = camera_get_view_height(cam);



following = oPlayer;

x_to = x;
y_to = y;

screenshake_amount = 0;
screenshake_length = 0;
screenshake_current = 0;

edge_buffer = 32;

shakeScreen = function(magnitude, length)
{
	screenshake_amount = magnitude;
	screenshake_current = magnitude;
	screenshake_length = length;
}

onScreen = function(x_coord, y_coord){
	if (abs(x-x_coord) < cam_width/2) and (abs(y-y_coord) < cam_height/2)
	{
		return true
	}
	return false
}