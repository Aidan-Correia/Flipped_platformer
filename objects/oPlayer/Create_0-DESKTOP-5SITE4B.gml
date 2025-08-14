 //initialize valuess
pos_x = x;
pos_y = y;

next_sprite = sPlayerIdle;

x_remainder = 0;
y_remainder = 0;

walk_spd = 3; 

max_jumps = 2;
curr_jumps = max_jumps;

jump_height = 4;

left_key = 0;
right_key = 0;

jump_key = 0;
jump_key_held = 0;
jump_key_rel = 0;

dash_key = 0;

flip_key = 0;


crouch_key = 0;
//crouch_key_rel = 0;

flipped = -1;
bounce = 1.25;
drift_bonus = 1.8;

dash_spd = 9;
dash_dir = 0;

grounded = false;

base_grav = .32
curr_grav = base_grav;

base_accel = 1;
curr_accel = base_accel;

spd_x = 0;
spd_y = 0;

momentum_y = 0;
momentum_x = 0;

jump_hang_accel_bonus = 1.25;
jump_hang_spd_bonus = 1.2;
jump_hang_threshold = 1.85;

run_jump_spd_bonus = 1.2; 


max_fall_spd = 10;
curr_max_fall_spd = max_fall_spd;
fastfall_bonus = 2.5;

air_drift_bonus = 1.2;

slow_grav_bonus = .5;

air_drag = .03;
ground_drag = .06;
 
//timer values
jump_buffer_max = 8;
flip_buffer_max = 8;
jump_buffer = 0;
flip_buffer = 0;


coyote_timer_max = 6;
coyote_timer = coyote_timer_max;


full_hop_timer_max = 20;
full_hop_timer = full_hop_timer_max;

tp_cooldown_max = 0;
tp_cooldown = 0;

dash_cooldown_max = 120;
dash_cooldown = 0;

momentum_x_timer_max = 6;
momentum_x_timer = 0;

momentum_y_timer_max = 6;
momentum_y_timer = 0; 

jump_squat_timer = 2;

//handler values

col_handler_x = collision_handlers.nothing;
col_handler_y = collision_handlers.nothing;

//state value

current_state = player_states.idle;






enum player_states
{
	idle = 0,
	walking = 1,
	crouching = 2,
	crouch_walk = 3,
	jumping = 4,
	jump_peak = 5,
	falling = 6,
	dash_start = 7,
	dash_peak = 8,
	dash_end = 9,
	land_squat = 10
	
	
}

execute_state = function()
{
	switch (current_state)
	{
		case player_states.idle:
			idleStateStep();
			break;
		case player_states.walking:
			walkingStateStep();
			break;
		case player_states.crouching:
			crouchStateStep();
			break;
		case player_states.crouch_walk:
			crouchWalkStateStep();
			break;
		case player_states.jumping:
			jumpStateStep();
			break;
		case player_states.jump_peak:
			jumpPeakStateStep();
			break;
		case player_states.falling:
			fallingStateStep();
			break;
		case player_states.dash_start:
			dashStartStateStep();
			break;
		case player_states.dash_peak:
			dashPeakStateStep();
			break;
		case player_states.dash_end:
			dashEndStateStep();
			break;
		case player_states.land_squat:
			landSquatStateStep();
			break;
	}
}




//state functions, executed each step
idleStateStep = function()
{
	
	coyote_timer = coyote_timer_max;
	curr_jumps = max_jumps;
	dash_cooldown = 0;
	
	
	curr_grav = base_grav;
	curr_accel = base_accel;
	
		var move = right_key - left_key;
		if (crouch_key)
		{
			sprite_index = sPlayerCrouch
			next_sprite = sPlayerCrouch;
			current_state = player_states.crouching;
			if (move != 0)
			{
				sprite_index = sPlayerCrouchWalk;
				next_sprite = sPlayerCrouchWalk;
				current_state = player_states.crouch_walk;	
			}
		}
		else if (move != 0)
		{
			sprite_index = sPlayerRun;
			next_sprite = sPlayerRun;
			current_state = player_states.walking;	
		}
		
		
		
		if (!isGrounded())
		{
			current_state = player_states.jump_peak;
		}
		
		
		flip();
		
		
		jump();
	
		dash();
	
	timerUpdate();
}

walkingStateStep = function()
{
	
	
	coyote_timer = coyote_timer_max;
	curr_jumps = max_jumps;
	dash_cooldown = 0;
	
	curr_grav = base_grav;
	curr_accel = base_accel;
	
	var move = right_key-left_key;
	
	var target_speed = move*walk_spd;
	
	
	
	//maintain momentum if traveling faster than max spd, but slowly decrement to walk speed
	if ((sign(spd_x) == move) and (abs(spd_x) > walk_spd))
	{
			curr_accel = ground_drag;
	}
	
	if (spd_x == 0)
	{
		if (crouch_key)
		{
			sprite_index = sPlayerCrouch
			next_sprite = sPlayerCrouch;
			current_state = player_states.crouching;	
		}
		else
		{
			sprite_index = sPlayerIdle;
			next_sprite = sPlayerIdle;
			current_state = player_states.idle;	
		}
	}
	
	else if (crouch_key and abs(spd_x) <= walk_spd)
	{
		sprite_index = sPlayerCrouchWalk;
		next_sprite = sPlayerCrouchWalk;
		current_state = player_states.crouch_walk;	
	}
	
	if (!isGrounded())
	{
		current_state = player_states.jump_peak;
	}
		
		
	else
	{
		flip();
	}
		
		jump();
		
		dash();
	
	spd_x = lerp(spd_x, target_speed, curr_accel);
	
	timerUpdate();
}

crouchStateStep = function()
{
	
	var move = right_key-left_key;
	
	coyote_timer = coyote_timer_max;
	curr_jumps = max_jumps;
	dash_cooldown = 0;
	
	curr_grav = base_grav;
	curr_accel = base_accel;
	
	if (move != 0)
	{
		if (crouch_key)
		{
			sprite_index = sPlayerCrouchWalk;
			next_sprite = sPlayerCrouchWalk;
			current_state = player_states.crouch_walk;
		}
		else
		{
			sprite_index = sPlayerRun;
			next_sprite = sPlayerRun;
			current_state = player_states.walking;	
		}
	}
	else if (!crouch_key)
	{
		sprite_index = sPlayerIdle;
		next_sprite = sPlayerIdle;
		current_state = player_states.idle;
	}
	if (!isGrounded())
	{
		current_state = player_states.jump_peak;
	}
	
	else
	{
		flip();	
	}
	
	jump();
	
	dash()
	
	timerUpdate();
}

crouchWalkStateStep = function()
{
	
	
	spd_x *= 1;
	coyote_timer = coyote_timer_max;
	
	curr_jumps = max_jumps;
	dash_cooldown = 0;
	
	curr_grav = base_grav;
	curr_accel = base_accel;
	
	var move = right_key-left_key;
	
	var target_speed = move*walk_spd/2;
	
	
	
	//maintain momentum if traveling faster than max spd, but slowly decrement to walk speed
	if ((sign(spd_x) == move) and (abs(spd_x) > walk_spd))
	{
			curr_accel = ground_drag;
	}
	
	if (spd_x == 0)
	{
		if (crouch_key)
		{
			sprite_index = sPlayerCrouch
			next_sprite = sPlayerCrouch;
			current_state = player_states.crouching;	
		}
		else
		{
			sprite_index = sPlayerIdle;
			next_sprite = sPlayerIdle;
			current_state = player_states.idle;	
		}
	}
	
	else if (!crouch_key)
	{
		sprite_index = sPlayerRun;
		next_sprite = sPlayerRun;
		current_state = player_states.walking;	
	}
	
	if (!isGrounded())
	{
		current_state = player_states.jump_peak;
	}
		
		
	
		flip();
		
		
		jump();
		
		dash();
	
	spd_x = lerp(spd_x, target_speed, curr_accel);
	
	timerUpdate();
}


jumpStateStep = function()
{
	if (abs(spd_x) > 0)
			{
				sprite_index = sPlayerJump;	
				next_sprite = sPlayerJump;
				image_index = 1;
				image_speed = 0;
			}
	else
			{
				sprite_index = sPlayerJumpStraight;	
				next_sprite = sPlayerJumpStraight;
				image_index = 1;
				image_speed = 0;
			}
	curr_accel = base_accel;
	
	var move = right_key-left_key;
	
	var target_speed = move*(walk_spd+drift_bonus);
	
	
	if (jump_key_rel or !full_hop_timer)
	{
		curr_grav = base_grav	
	}
	/*
	if (coyote_timer == 0)
	{
		curr_jumps--;	
	}*/
	
	
	//maintain momentum if traveling faster than max spd, but slowly decrement to walk speed
	if ((sign(spd_x) == move) and (abs(spd_x) > walk_spd+drift_bonus))
	{
			curr_accel = air_drag;
	}
	
	
	if (abs(spd_y) < jump_hang_threshold)
	{
		current_state = player_states.jump_peak;	
	}
	
	if (coyote_timer == 0 and curr_jumps == max_jumps)
	{
		curr_jumps--;	
	}
	
	
	if(isGrounded())
	{
		current_state = player_states.land_squat;
	}
	
	/*
	if (crouch_key)
	{
		target_speed *= .5;
		curr_accel *= .6;
	}*/
	
	flip();
	
	jump();
	
	dash();
	
	spd_x = lerp(spd_x, target_speed, curr_accel);
	
	spd_y -= flipped*curr_grav;
	
	timerUpdate();
}


jumpPeakStateStep = function()
{
	
	curr_grav = base_grav*slow_grav_bonus;
	curr_accel = base_accel*jump_hang_accel_bonus;
	
	var move = right_key-left_key;
	
	var target_speed = jump_hang_spd_bonus*move*(walk_spd+drift_bonus);
	
	if (coyote_timer == 0 and curr_jumps == max_jumps)
	{
		curr_jumps--;	
	}
	
	jumpPeakBoost();
	
	if(isGrounded())
	{
		current_state = player_states.land_squat;	
	}
	
	else
	{
		if (spd_y*flipped > 0)
		{
			if (abs(spd_x) > 0)
			{
				sprite_index = sPlayerFall;	
				next_sprite = sPlayerFall;
				image_index = 0;
				image_speed = 0;
			}
			else
			{
				sprite_index = sPlayerFallStraight;	
				next_sprite = sPlayerFallStraight;
				image_index = 0;
				image_speed = 0;
			}
		}
		
		}
		
		if (abs(spd_y) > jump_hang_threshold)
		{
		current_state = player_states.falling;	
		}
	
	/*
	if (crouch_key)
	{
		curr_accel *= .6;
		target_speed *= .5;
	}*/
	
	flip();
	
	jump();
	
	dash();
	
	spd_y -= flipped*curr_grav;
	spd_x = lerp(spd_x, target_speed, curr_accel);
	
	timerUpdate();
}

fallingStateStep = function()
{
	if (abs(spd_x) > 0)
			{
				sprite_index = sPlayerFall;	
				next_sprite = sPlayerFall;
				image_index = 0;
				image_speed = 0;
			}
	else
			{
				sprite_index = sPlayerFallStraight;	
				next_sprite = sPlayerFallStraight;
				image_index = 0;
				image_speed = 0;
			}
	
	curr_max_fall_spd = max_fall_spd;
	curr_accel = base_accel;
	curr_grav = base_grav*slow_grav_bonus; //??
	
	var move = right_key-left_key;
	
	var target_speed = move*(walk_spd+drift_bonus);
	
	if (coyote_timer == 0 and curr_jumps == max_jumps)
	{
		curr_jumps--;	
	}
	
	if(isGrounded())
	{
		current_state = player_states.land_squat;
		
	}
	
	flip();
	
	if (crouch_key)
	{
		curr_max_fall_spd = max_fall_spd*fastfall_bonus;
		//curr_accel *= .6;
		//target_speed *= .5;
	}
	
	jump();
	
	dash();
	
	spd_y -= flipped*curr_grav;
	spd_y = clamp(spd_y, -1*curr_max_fall_spd, curr_max_fall_spd);
	momentum_y = spd_y;
	momentum_y_timer = momentum_y_timer_max;
	
	spd_x = lerp(spd_x, target_speed, curr_accel);
	
	timerUpdate();
}

dashStartStateStep = function()
{
	sprite_index = sPlayerRun;	
	next_sprite = sPlayerRun;
	image_index = 0;
	image_speed = 0;
	
	spd_y = 0;
	momentum_x = spd_x;
	
	spd_x = 0
	
	if (dash_cooldown == dash_cooldown_max-3)
	{
		dash_dir = image_xscale;
		current_state = player_states.dash_peak;	
	}
	
	timerUpdate();
}

dashPeakStateStep = function()
{
	//var dir = image_xscale;
	image_xscale = dash_dir;
	spd_y = 0;
	spd_x = momentum_x + dash_dir*dash_spd;
	
	if (dash_cooldown == dash_cooldown_max-28)
	{
		current_state = player_states.dash_end;	
	}
	
	jumpPeakBoost();
	
	flip();
	
	jump();
	
	timerUpdate();
}

dashEndStateStep = function()
{
	spd_y -= flipped*curr_grav;
	var move = right_key-left_key;
	
	if isGrounded()
	{
		target_speed = move*walk_spd;
		current_state = player_states.walking	
		
	}
	else
	{
		var target_speed = jump_hang_spd_bonus*move*(walk_spd+drift_bonus);
		current_state = player_states.jump_peak;	
	}
	
	
	flip();
	
	jump();
	
	timerUpdate();
}


landSquatStateStep = function()
{
	sprite_index = sPlayerFall;
	image_index = 1;
	image_speed = 1;
	if (spd_x == 0)	
		{
			if (crouch_key)
			{
				sprite_index = sPlayerCrouch;
				next_sprite = sPlayerCrouch;
				current_state = player_states.crouching;
			}
			else
			{
				next_sprite = sPlayerIdle;
				current_state = player_states.idle;
			}
		}
		else
		{
			if (crouch_key and abs(spd_x) <= walk_spd)
			{
				sprite_index = sPlayerCrouchWalk;
				next_sprite = sPlayerCrouchWalk;
				current_state = player_states.crouch_walk;
			}
			else
			{
				next_sprite = sPlayerRun;
				current_state = player_states.walking;
			}	
		}
		
		momentum_y = spd_y;
		
		momentum_y_timer = momentum_y_timer_max;
		
		spd_y = 0;
		
}

timerUpdate = function()
{
	tp_cooldown = max(0, tp_cooldown-1);
	jump_buffer = max(0, jump_buffer-1);
	flip_buffer = max(0, flip_buffer-1);
	momentum_y_timer = max(0, momentum_y_timer-1);
	momentum_x_timer = max(0, momentum_x_timer-1);
	coyote_timer = max(-1, coyote_timer-1);
	full_hop_timer = max(0, full_hop_timer-1);
	dash_cooldown = max(0, dash_cooldown-1);
}


jumpPeakBoost = function()
{
	var curr_collider;
	var collision_list = ds_list_create();
	var is_collision = false;
	var still_collision = false;
	var num = instance_place_list(pos_x+spd_x,pos_y, oSolidFlipped, collision_list, false);
			
	for (var i = 0; i < num; i++)
				{
					curr_collider = ds_list_find_value(collision_list, i);
					if(curr_collider.flipped != flipped*-1 and curr_collider.collidable == true)
					{
						i = num+1;	
						is_collision = true;
					}
				}
	ds_list_clear(collision_list);
	
	if (is_collision)
	{
		num = instance_place_list(pos_x+spd_x,pos_y+(flipped*11), oSolidFlipped, collision_list, false);
			
		for (var i = 0; i < num; i++)
				{
					curr_collider = ds_list_find_value(collision_list, i);
					if(curr_collider.flipped != flipped*-1 and curr_collider.collidable == true)
					{
						still_collision = true	
					}
				}
		if (!still_collision)
		{
			
			pos_y += (flipped*11);
		}
	}
	ds_list_destroy(collision_list);
}

flip = function()
{ 
	if (((flip_key or flip_buffer) and !tp_cooldown) and isFlippable())
	{
		flipped *=-1;
	
		pos_y += flipped*abs(sprite_height);
		spd_y = bounce*flipped;
		
		image_yscale *= -1
		if(momentum_y_timer)
		{
			spd_y += momentum_y;
		}
		
		current_state = player_states.jumping;
		tp_cooldown = tp_cooldown_max;
			
		flip_buffer = 0;
		
		curr_jumps = max_jumps;
		coyote_timer = 3;
	
		/*play flipped effect */
	}
	else if (flip_key)
	{
		flip_buffer = flip_buffer_max;
	}
}

jump = function()
{
	if ((jump_key or jump_buffer) and curr_jumps)
		{
			sprite_index = sPlayerJump;
			next_sprite = sPlayerJump;
			current_state = player_states.jumping;
			full_hop_timer = full_hop_timer_max;
			
			jump_buffer = 0;
			curr_jumps--;
			
			spd_y  = jump_height*flipped;
			spd_x = spd_x + (drift_bonus*sign(spd_x));
			
			curr_grav = 0;
			
			
			/*play jump particles */
		}
	else if (jump_key){
		jump_buffer = jump_buffer_max;	
	}
}

dash = function()
{
	if (dash_key and !dash_cooldown)
	{
		current_state = player_states.dash_start;
		dash_cooldown = dash_cooldown_max;
		
	}
}

/*collision handling function
game maker doesn't really support parametrized function pointers, so i utilitze a local method with a switch statement
function is passed a number from an enumerator, runs a switch statement 
to execute the collision handling code based on the value pased*/
handleCollision = function(collision_case)
{
	switch(collision_case)
	{
		case collision_handlers.nothing:
			break;
		case collision_handlers.squeeze:
			playDeath();
			break;
	}
}

/*call this function upon dying, should restart level ad play dying/respawning animations*/
playDeath = function()
{
	game_restart();	
}

//returns true if we are "riding" the given instance, matters for moving platforms as they will "carry" us if they do not move into us
isRiding = function(solidInstance)
{
	if place_meeting(x, y - flipped, solidInstance)
	{
		return true;
	}
	return false;
}


//moves player given amount in respective direction
moveX = function(move_amount, collision_type)
{
	
	x_remainder += move_amount;
	var move = round(x_remainder);
	
	if (move != 0)
	{
		x_remainder -= move;
		var step = sign(move);
		var collision_list = ds_list_create();
		var num;
		var collision = false;
		var curr_collider;
		
		while (move != 0)
		{
			num = instance_place_list(pos_x+step,pos_y, oSolidFlipped, collision_list, false);
			
				for (var i = 0; i < num; i++)
				{
					curr_collider = ds_list_find_value(collision_list, i);
					if(curr_collider.flipped != flipped*-1 and curr_collider.collidable == true)
					{
						i = num+1;	
						move = 0;
					
						handleCollision(collision_type);
					}
				}
				pos_x += sign(move);
				move -= sign(move);
				ds_list_clear(collision_list);
		}
		ds_list_destroy(collision_list);
	}
}

moveY = function(move_amount, collision_type)
{
	y_remainder += move_amount;
	var move = round(y_remainder);
	
	if (move != 0)
	{
		y_remainder -= move;
		var step = sign(move);
		var collision_list = ds_list_create();
		var num;
		var curr_collider;
		
		while (move != 0)
		{
			    num = instance_place_list(pos_x, pos_y+step, oSolidFlipped, collision_list, false);
		
				for (var i = 0; i < num; i++)
				{
					curr_collider = ds_list_find_value(collision_list, i);
					if(curr_collider.flipped != flipped*-1 and curr_collider.collidable == true)
					{
						i = num+1;	
						move = 0;
					
						handleCollision(collision_type);
					}
				}
				
				pos_y += sign(move);
				move -= sign(move);
				ds_list_clear(collision_list);
		}
		ds_list_destroy(collision_list);
	}
	
}

getInput = function()
{
	left_key = keyboard_check(vk_left);
	right_key = keyboard_check(vk_right);

	jump_key = keyboard_check_pressed(vk_space);
	jump_key_held = keyboard_check(vk_space);
	jump_key_rel = keyboard_check_released(vk_space);

	flip_key = keyboard_check_pressed(ord("Z"));

	dash_key = keyboard_check_pressed(vk_shift);

	crouch_key = keyboard_check(vk_down);
		
}

moveSelf = function()
{
	moveX(spd_x, col_handler_x);
	moveY(spd_y, col_handler_y);

	x = pos_x;
	y = pos_y;
}

isGrounded = function()
{
	var collision_list = ds_list_create();
	var curr_collider;
	var count = instance_place_list(pos_x, pos_y - flipped, oSolidFlipped, collision_list, false );
	for(var i = 0; i < count; i++)
	{
		curr_collider = ds_list_find_value(collision_list, i);
		if(curr_collider.flipped != flipped*-1 and curr_collider.collidable == true)
		{
			return true;
		}
	}
	return false;
	ds_list_destroy(collision_list);
}

isFlippable = function()
{
	
	
	var collision_list = ds_list_create();
	var curr_collider;
	var count = instance_place_list(pos_x, pos_y - flipped*32, oSolidFlipped, collision_list, false );
	for(var i = 0; i < count; i++)
	{
		curr_collider = ds_list_find_value(collision_list, i);
		if(curr_collider.flipped != flipped and curr_collider.collidable == true)
					{
					ds_list_destroy(collision_list);
					return false;
					}
	}
	
	ds_list_clear(collision_list);
	
	count = instance_place_list(pos_x, pos_y - flipped, oSolidFlipped, collision_list, false );
	for(var i = 0; i < count; i++)
	{
		curr_collider = ds_list_find_value(collision_list, i);
		if(curr_collider.flipped == flipped and curr_collider.collidable == true)
		{
			ds_list_destroy(collision_list);
			return true;
		}
					
	}	
	ds_list_destroy(collision_list);
	return false;
}