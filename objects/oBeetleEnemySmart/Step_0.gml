/// @description Insert description here
// You can write your code in this editor
if (true)
{
	
	var target_speed = sign(oPlayer.pos_x-pos_x)*walk_spd;

	spd_x = lerp(spd_x, target_speed, .08);

	spd_y -= flipped*beetle_grav;

	if (spd_x != 0)
	{
		image_xscale = sign(spd_x);	
	}

	moveSelf(spd_x,spd_y);
	
	idle_step_timer = 1;
	idle_dir = image_xscale
}
else
{
	var target_speed = walk_spd*idle_dir;
	spd_x = lerp(spd_x, target_speed, .08);
	if(!idle_step_timer)
	{
		idle_dir *= -1;	
		image_xscale *= -1;
	}
	
	idle_step_timer = (idle_step_timer+1)%45
	
	moveSelf(spd_x, spd_y);
}

