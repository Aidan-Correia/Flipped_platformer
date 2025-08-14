/// @description Insert description here
// You can write your code in this editor

// You can write your code in this editor

event_inherited();

current_state = hopper_states.jump;
flipped = -1;

spd_x = 0;
spd_y = 0;
jump_height_max = 55;
jump_height_min = 3.5;

jump_length_max = 130;

target_x = 0;
jump_dir = 0;


air_speed = 2.5;

hopper_grav = .35;
jump_cooldown_max = 40
jump_cooldown = 0;
floor_check_list = ds_list_create()
floor_list = []

sub_room_containing = 0;



enum hopper_states
{
	idle = 0,
	jump_start = 1,
	jump = 2,
	landing = 3
}

executeStep = function()
{
	switch (current_state)	
	{
		case hopper_states.idle:
			idleStateStep();
			break;
		case hopper_states.jump_start:
			jumpStartStateStep();
			break;
		case hopper_states.jump:
			jumpStateStep();
			break;
		case hopper_states.landing:
			landStateStep();
			break;
		
		
	}
}

inSightline = function()
{
	
	if((flipped = oPlayer.flipped)and(abs(pos_x-oPlayer.pos_x)<100))
	{
		return true	
	}
	return false
}

calculateLaunch = function(target)
{
	
	
	var target_distance = clamp(target.pos_x-pos_x, -1*jump_length_max, jump_length_max);
	target_x = pos_x + target_distance;
	jump_dir = sign(target_distance);
	var target_airtime = abs(target_distance)/air_speed;
	var target_y = max((target.pos_y-pos_y)*flipped, 0);
	var target_spd = sqrt(((target_y)*2*hopper_grav));
	
	spd_y = flipped*min(max(((target_airtime*hopper_grav)/2), target_spd, jump_height_min),jump_height_max);
	
}




idleStateStep = function()
{
	
	if (inSightline() and !jump_cooldown)
	{
		current_state = hopper_states.jump_start;
		sprite_index = sHopperJump;
		image_index = 0;
		image_speed = 1;
		
	}
	
	jump_cooldown = max(jump_cooldown-1,0)
}

jumpStartStateStep = function()
{
	if (image_index = 8)
	{
		current_state = hopper_states.jump;
		image_index = 9
		image_speed = 0;
		calculateLaunch(oPlayer);
	}
	
	return
}

jumpStateStep = function()
{
	spd_y -= flipped*hopper_grav;
	if spd_y*flipped <= 0
	{
		sprite_index = sHopperFall;
		image_speed = 0;
	}
	var target_spd = air_speed*jump_dir;
	if (abs(spd_y) < 1.5)
	{
		target_spd *= 1.3;	
	}
	if(sign(target_x-pos_x) != jump_dir)
	{
		target_spd = 0;
	}
	spd_x = lerp(spd_x, target_spd,.77);
	floor_list = []
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
	if (num != 0)
	{
		current_state = hopper_states.landing;
		sprite_index = sHopperJump;
		image_index = 8;
		image_speed = -1;
	}
	floor_list = []
	return
}


landStateStep = function()
{
	spd_y = 0;
	spd_x = 0;
	
	if (image_index = 0)
	{
		current_state = hopper_states.idle;
		sprite_index = sHopperIdle;
		image_speed = 1;
		jump_cooldown = jump_cooldown_max;
		
	}
	return
}

playDeath = function()
{
	instance_destroy(self);
}




