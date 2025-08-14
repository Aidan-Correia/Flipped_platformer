/// @description Insert description here
// You can write your code in this editor

event_inherited();

current_state = gollum_states.idle;
sightline = [200, 75]
alert_pause_max = 4;
alert_pause = alert_pause_max;
spd_x = 0;
spd_y = 0;
jump_height = 12;
gollum_grav = .35;
jump_cooldown_max = 140
jump_cooldown = 0;
floor_check_list = ds_list_create()
floor_list = []
gollum_freeze_amount = 75;

pos_x = x;
pos_y = y;


enum gollum_states
{
	idle = 0,
	alerted = 1,
	jump_start = 2,
	jump = 3,
	jump_finish = 4
}

executeStep = function()
{
	switch (current_state)	
	{
		case gollum_states.idle:
			idleStateStep();
			break;
		case gollum_states.alerted:
			alertedStateStep();
			break;
		case gollum_states.jump_start:
			jumpStartStateStep();
			break;
		case gollum_states.jump:
			jumpStateStep();
			break;
		case gollum_states.jump_finish:
			jumpFinishStateStep();
			break;
		
		
	}
}

inSightline = function(entity)
{
	
	if(((entity.pos_x >= pos_x-sightline[0]) and (entity.pos_x <= pos_x+sightline[0])) 
	and (((entity.pos_y >= pos_y-sightline[1]) and (entity.pos_y <= pos_y+sightline[1])) and (entity.flipped = flipped)))
	{
		return true	
	}
	return false
}

idleStateStep = function()
{
	
	if (inSightline(oPlayer) and !jump_cooldown)
	{
		current_state = gollum_states.alerted;
		sprite_index = sGollumAlert;
		alert_pause = alert_pause_max;
		
	}
	
	jump_cooldown = max(jump_cooldown-1,0)
}

alertedStateStep = function()
{
	if (!alert_pause)
	{
		current_state = gollum_states.jump_start;
		sprite_index = sGollumSquat;
		image_speed = 1;
		image_index = 0
	}
	alert_pause = max(alert_pause-1,0)
	return
}

jumpStartStateStep = function()
{
	if (image_index == 5)
	{
		sprite_index = sGollumJump;
		image_speed = 0
		current_state = gollum_states.jump;
		spd_y = flipped*jump_height
	}
	return
}

jumpStateStep = function()
{	
	spd_y -= gollum_grav*flipped;
	if spd_y*flipped < 0
	{
		sprite_index = sGollumFall;
		image_speed = 0;
	}
	var num = instance_place_list(pos_x, pos_y-flipped, curr_solid,floor_check_list, false);
	for (var i = 0; i < num; i++)
				{
					var curr_collider = ds_list_find_value(floor_check_list, i);
					if(curr_collider.collidable == true)
					{
						array_push(floor_list, curr_collider)
					}
				
				}
	ds_list_clear(floor_check_list)
	
	num = array_length(floor_list)
	if (num > 0)
	{
		if (inSightline(oPlayer))
		{
			oCamera.shakeScreen(12, 80)	
		}
		
		for(var i =0; i < num; i++)
		{
			if oPlayer.isRiding(floor_list[i])
			{
				
				oPlayer.current_state = player_states.frozen;
				oPlayer.frozen_timer = gollum_freeze_amount;
				i = num
			}
		}
		current_state = gollum_states.jump_finish;
		sprite_index = sGollumSquat
		image_index = 3
		image_speed = -1;
		jump_cooldown = jump_cooldown_max;
	}
	floor_list = [];
	return
}

jumpFinishStateStep = function()
{
	spd_y = 0;
	
	if (image_index = 5)
	{
		sprite_index = sGollumIdle;
		image_index = 0;
		image_speed = 1;
		current_state = gollum_states.idle;
	}
	return
}

playDeath = function()
{
	instance_destroy(self);
}