/// @description Insert description here
// You can write your code in this editor


if (following != noone)
{
	x_to = following.x;
	y_to = following.y;
}

x += (x_to-x)/10;
y += (y_to-y)/10;

x = clamp(x, 0+(cam_width*.5)+edge_buffer, room_width-(cam_width*.5)-edge_buffer);
y = clamp(y, 0+(cam_height*.5)+edge_buffer, room_height-(cam_height*.5)-edge_buffer);


x += random_range(-screenshake_current, screenshake_current);
y += random_range(-screenshake_current, screenshake_current);

screenshake_current = max(0, screenshake_current-((1/screenshake_length)*screenshake_amount));

camera_set_view_pos(cam, x - (cam_width*.5), y - (cam_height*.5));
