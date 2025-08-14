 //initialize valuess
event_inherited()
debug_timer = 0;


pos_x = x;
pos_y = y;

momentum_tracker = instance_create_layer(pos_x,pos_y,"player",oMomentumTracker);

x_squish_amount = 1;
y_squish_amount = 1;

jump_squish = 1;
squish_lerp = .08;

next_sprite = sPlayerIdle;

x_remainder = 0;
y_remainder = 0;


walk_spd = 2.75; 
climb_height = 8;

bonk_dodge_width = 6;

max_jumps = 2;
curr_jumps = max_jumps;

jump_height = 4;
jump_decrease_cons = .77;

left_key = 0;
right_key = 0;

up_key = 0;
down_key = 0;

jump_key = 0;
jump_key_held = 0;
jump_key_rel = 0;

dash_key = 0;

flip_key = 0;


crouch_key = 0;
//crouch_key_rel = 0;

flipped = -1;
bounce = 1.5;
drift_bonus = 1.5;

dash_spd = 12;
dash_dir = 1;
dash_angle_up = .25;
dash_angle_down = .5;

grounded = false;


base_grav = .5;
curr_grav = base_grav;

base_accel = 3;
curr_accel = base_accel;
base_air_accel = base_accel*.7;
base_crouch_accel = base_accel*.03;

grounded_drag_accel = base_accel*.15;
air_drag_accel = base_air_accel*.1;
crouch_drag_accel = base_accel*.01;


spd_x = 0;
spd_y = 0;

fall_grav = base_grav*.4

jump_peak_grav = base_grav*.4;
jump_hang_threshold = 1.8;

run_jump_spd_bonus = 1.5; 



max_fall_spd = 12;
curr_max_fall_spd = max_fall_spd;
fastfall_bonus = 1;




 
//timer values
jump_buffer_max = 8;
flip_buffer_max = 10;
jump_buffer = 0;
flip_buffer = 0;


coyote_timer_max = 6;
coyote_timer = coyote_timer_max;


full_hop_timer_max = 14;
full_hop_timer = full_hop_timer_max;

tp_cooldown_max = 0;
tp_cooldown = 0;

dash_cooldown_max = 65;
dash_cooldown = 0;



step_sound_timer = 0;
//jump_squat_timer = 2;
frozen_timer = 0;
//handler values

//state value

current_state = player_states.idle;

jitter = 0;
base_jitter_amount = 5;
jitter_amount_y = 0;
jitter_amount_x = 0;

paralyzed = 0;

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
	land_squat = 10,
	frozen = 11
	
}

executeState = function()
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
		case player_states.frozen:
			frozenStateStep();
			break;

	}
}



getInput = function()
{
	
left_key = keyboard_check(vk_left);
right_key = keyboard_check(vk_right);

up_key = keyboard_check(vk_up);
down_key = keyboard_check(vk_down);

jump_key = keyboard_check_pressed(vk_space);
jump_key_held = keyboard_check(vk_space);
jump_key_rel = keyboard_check_released(vk_space);

dash_key = keyboard_check_pressed(vk_shift);

flip_key = keyboard_check_pressed(ord("Z"));

if (flipped)
{
	crouch_key = keyboard_check(vk_up);
}
else
{
	crouch_key = keyboard_check(vk_down);
}
}


calcAccel = function(accel, drag_accel, target_speed)
{
	curr_accel = (target_speed-spd_x)*accel;
	
	if ((sign(spd_x) = sign(target_speed)) and (abs(spd_x) > abs(target_speed)))
	{
			curr_accel = (target_speed-spd_x)*drag_accel;
	}
	
	if (abs(target_speed-spd_x)<abs(curr_accel))
	{
		spd_x=target_speed	
	}
	else
	{
		spd_x += curr_accel;	
	}
	
}
//state functions, executed each step


frozenStateStep = function()
{
	curr_grav = base_grav;
	
	spd_x = 0;
	spd_y = 0;
	jitter = 1;
	jitter_amount_x = base_jitter_amount;
	image_speed = 0;
	if !(frozen_timer)
	{
		jitter = 0;
		jitter_amount_x = 0;
		var move = right_key-left_key;
		if isGrounded()
		{
			var target_speed = move*walk_spd;
			if (target_speed != 0)
			{
				current_state = player_states.walking	
				sprite_index = sPlayerRun;	
				image_speed = 1;
				next_sprite = sPlayerRun;
			}
			else
			{
				current_state = player_states.idle	
				sprite_index = sPlayerIdle;	
				image_speed = 1;
				next_sprite = sPlayerIdle;
			}
		
		}
		else
		{
			
			current_state = player_states.falling;	//fix if else chain, seperate to function, call here
		}
		
	}
	
}

idleStateStep = function()
{
	x_squish_amount = lerp(x_squish_amount, 1, squish_lerp); //??????
	
	coyote_timer = coyote_timer_max;
	curr_jumps = max_jumps;
	
	
	
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
			sprite_index = sPlayerFall;	
			next_sprite = sPlayerFall;
			image_index = 0;
			image_speed = 0;
			current_state = player_states.falling;
		}
		
		
		flip();
		
		
		jump();
	
		dash();
	
	
}

walkingStateStep = function()
{
	
	
	coyote_timer = coyote_timer_max;
	curr_jumps = max_jumps;
	
	
	curr_grav = base_grav;
	
	
	var move = right_key-left_key;
	
	var target_speed = move*walk_spd;
	
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
	//if greater than walk spd, enter slide
	
	if (!isGrounded())
	{
		sprite_index = sPlayerFall;	
		next_sprite = sPlayerFall;
		image_index = 0;
		image_speed = 0;
		current_state = player_states.falling;
	}
	
		
	calcAccel(base_accel,grounded_drag_accel,target_speed);
	
	flip();	
	jump();	
	dash();
	
		
}

crouchStateStep = function()
{
	
	
	var move = right_key-left_key;
	
	coyote_timer = coyote_timer_max;
	curr_jumps = max_jumps;
	
	
	curr_grav = base_grav;
	var target_speed = move*walk_spd/2;
	
	if (move != 0)
	{
		if (!crouch_key and uncrouchable())
		{
			sprite_index = sPlayerRun;
			next_sprite = sPlayerRun;
			current_state = player_states.walking;
			
			
		}
		else
		{
			sprite_index = sPlayerCrouchWalk;
			next_sprite = sPlayerCrouchWalk;
			current_state = player_states.crouch_walk;	
		}
	}
	else if (!crouch_key and uncrouchable())
	{
		sprite_index = sPlayerIdle;
		next_sprite = sPlayerIdle;
		current_state = player_states.idle;
	}
	if (!isGrounded())
	{
		sprite_index = sPlayerFall;	
		next_sprite = sPlayerFall;
		image_index = 0;
		image_speed = 0;
		current_state = player_states.falling;
	}
	
	calcAccel(base_crouch_accel,crouch_drag_accel,target_speed);
	
	flip();	

	if (uncrouchable())
	{
		jump();
	
		dash()
	}
	
	
}

crouchWalkStateStep = function()
{
	
	
	
	coyote_timer = coyote_timer_max;
	
	curr_jumps = max_jumps;
	
	
	curr_grav = base_grav;
	
	var move = right_key-left_key;
	
	var target_speed = move*walk_spd/2;
	
	
	
	//maintain momentum if traveling faster than max spd, but slowly decrement to walk speed
	
	
	if (!crouch_key and uncrouchable())
	{
		if (spd_x == 0)
		{
			sprite_index = sPlayerIdle;
			next_sprite = sPlayerIdle;
			current_state = player_states.idle;
		}
		else
		{
		
			
			sprite_index = sPlayerRun
			next_sprite = sPlayerRun;
			current_state = player_states.walking;
		}
	}
	
	else if (move == 0)
	{
		sprite_index = sPlayerCrouch;
		next_sprite = sPlayerCrouch;
		current_state = player_states.crouching;	
	}
	
	if (!isGrounded())
	{
		sprite_index = sPlayerFall;	
		next_sprite = sPlayerFall;
		image_index = 0;
		image_speed = 0;
		current_state = player_states.falling;
	}
	
	
	calcAccel(base_crouch_accel,crouch_drag_accel,target_speed);
	
	flip();
		
	if (uncrouchable())
	{
		jump();
		
		dash(); 
	}
	
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
	curr_accel = base_air_accel;
	
	var move = right_key-left_key;
	
	var target_speed = move*(walk_spd+run_jump_spd_bonus);
	
	
	if (((!jump_key_held and (full_hop_timer<full_hop_timer_max-3)) or !full_hop_timer) or (abs(spd_y)>jump_height))
	{
		curr_grav = base_grav	
	}
	
	if ((sign(spd_x) == move) and (abs(spd_x) > walk_spd+run_jump_spd_bonus))
	{
			curr_accel = air_drag_accel;
	}
	
	calcAccel(curr_accel,air_drag_accel,target_speed);
	spd_y -= flipped*curr_grav;
	
	
	if (abs(spd_y) < jump_hang_threshold)
	{
		current_state = player_states.jump_peak;	
	}
	
	if (coyote_timer == 0 and curr_jumps == max_jumps)
	{
		curr_jumps--;	
	}
	
/*	
	if(isGrounded())
	{
		audio_play_sound(sdLand, 4, false);
		current_state = player_states.land_squat;
		
		if !(((flip_key or flip_buffer) and !tp_cooldown) and isFlippable())
		{	
			playEffect(pos_x, pos_y, sLandEffect, sign(image_xscale), sign(image_yscale), flipped);
		}
	}
	*/
	
	
	flip();
	
	jump();
	
	dash();
	
	
	
	
}


jumpPeakStateStep = function()
{
	
	curr_grav = jump_peak_grav;
	curr_accel = base_air_accel*1.2;
	
	
	
	var move = right_key-left_key;
	
	var target_speed = 1.2*move*(walk_spd+drift_bonus);
	
	/*if (coyote_timer == 0 and curr_jumps == max_jumps)
	{
		curr_jumps--;	
	}*/
	
	jumpPeakBoost();
	/*
	if(isGrounded())
	{
		audio_play_sound(sdLand, 4, false);
		current_state = player_states.land_squat;	
		if !(((flip_key or flip_buffer) and !tp_cooldown) and isFlippable())
		{	
			playEffect(pos_x, pos_y, sLandEffect,  flipped);
		}
	}
	*/
	//else
	//{
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
		
		//}
		
		if (abs(spd_y) > jump_hang_threshold)
		{
		current_state = player_states.falling;	
		}
	
	
	
	spd_y -= flipped*curr_grav;
	calcAccel(curr_accel,air_drag_accel,target_speed);
	flip();
	
	jump();
	
	dash();
	
	
	
	
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
	curr_grav = fall_grav;
	
	var move = right_key-left_key;
	
	var target_speed = move*(walk_spd+drift_bonus);
	
	if (coyote_timer == 0 and curr_jumps == max_jumps)
	{
		curr_jumps--;	
	}
	
	if(isGrounded())
	{
		current_state = player_states.land_squat;
		if !(((flip_key or flip_buffer) and !tp_cooldown) and isFlippable())
		{	
			script_execute(playEffect,pos_x, pos_y, sLandEffect, flipped, image_xscale);
		}
		audio_play_sound(sdLand, 4, false);
		
	}
	
	if (crouch_key)
	{
		curr_max_fall_spd = max_fall_spd*fastfall_bonus;
		
	}
	
	spd_y -= flipped*curr_grav;
	spd_y = clamp(spd_y, -1*curr_max_fall_spd, curr_max_fall_spd);
	
	
	
	calcAccel(curr_accel,air_drag_accel,target_speed);
	
	flip();
	
	
	jump();
	
	dash();
	
	
	
	
}

dashStartStateStep = function()
{
	
	sprite_index = sPlayerDashStart;	
	next_sprite = sPlayerDashStart;
	image_index = 0;
	image_speed = 0;
	
	spd_y = 0;
	
	
	spd_x = 0
	
	if (dash_cooldown == dash_cooldown_max-6)
	{
		
		dash_dir = right_key-left_key;
		if (dash_dir == 0)
		{
			dash_dir = image_xscale;	
		}
		script_execute(playEffect,pos_x, pos_y, sDashEffect, flipped, dash_dir,image_xscale);
		current_state = player_states.dash_peak;	
		
		
	}
	
	if (jump_key and curr_jumps)
	{
		jump_buffer = jump_buffer_max;	
	}
	
}

dashPeakStateStep = function()
{
	sprite_index = sPlayerDash;	
	next_sprite = sPlayerDash;
	curr_grav = 0;
	
	
	spd_x =  dash_dir*dash_spd;
	var move_y = down_key-up_key;
	if (move_y = flipped)
	{
		spd_y += move_y*dash_angle_up;
	}
	else
	{
		spd_y += move_y*dash_angle_down;
	}
	image_xscale = dash_dir;
	
	if (dash_cooldown <= dash_cooldown_max-20)
	{
		/*sprite_index = sPlayerFall;	
		next_sprite = sPlayerFall;
		image_index = 0;
		image_speed = 0;*/
		current_state = player_states.dash_end;	
	}
	
	jumpPeakBoost();
	
	flip();
	
	jump();
	
	
}

dashEndStateStep = function()
{
	
	
	spd_y -= flipped*curr_grav;
	var move = right_key-left_key;
	
	
	
	if isGrounded()
	{
		
		/*current_state = player_states.land_squat;
		if !(((flip_key or flip_buffer) and !tp_cooldown) and isFlippable())
		{	
			script_execute(playEffect,pos_x, pos_y, sLandEffect, flipped, image_xscale);
		}
		audio_play_sound(sdLand, 4, false);
		*/
		/*
		if (crouch_key)
		{
			sprite_index = sPlayerCrouchWalk;
			next_sprite = sPlayerCrouchWalk;
			current_state = player_states.crouch_walk;	
			image_speed = 1;
			
		}
		else
		{
			sprite_index = sPlayerRun;
			next_sprite = sPlayerRun;
			current_state = player_states.walking;	
		}*/
		
	}


	
	
	flip();
	
	jump();
	
	if (current_state = player_states.dash_end)
	{
		if (isGrounded())
		{
			dash_cooldown=0;
			if (crouch_key)
			{
				if (move != 0)	
					{
						sprite_index = sPlayerCrouchWalk;
						next_sprite = sPlayerCrouchWalk;
						current_state = player_states.crouch_walk;	
						image_speed = 1;
			
					}
				else
					{
						sprite_index = sPlayerCrouch;
						next_sprite = sPlayerCrouch;
						current_state = player_states.crouching;
					}
			}
			else
			{
				spd_y = bounce*flipped;
				current_state = player_states.jumping;
			}
		}
		else
		{
			sprite_index = sPlayerFall;	
			next_sprite = sPlayerFall;
			image_index = 0;
			image_speed = 0;
			current_state = player_states.falling;
		}
	}
	
	
}


landSquatStateStep = function()
{
	dash_cooldown = 0;
	spd_y = 0;
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
			if (crouch_key)
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
		
		
		
		
		flip();
		jump();
		
}

timerUpdate = function()
{
	tp_cooldown = max(0, tp_cooldown-1);
	jump_buffer = max(0, jump_buffer-1);
	flip_buffer = max(0, flip_buffer-1);
	coyote_timer = max(-1, coyote_timer-1);
	full_hop_timer = max(0, full_hop_timer-1);
	dash_cooldown = max(0, dash_cooldown-1);
	frozen_timer = max(0, frozen_timer-1);
}


jumpPeakBoost = function()
{
	if (!checkLocation(pos_x+spd_x,pos_y,curr_solid) and checkLocation(pos_x+spd_x,pos_y+(10*flipped),curr_solid))
	{
		pos_y += (12*flipped);
	}
}

flip = function()
{ 
	if (((flip_key or flip_buffer) and !tp_cooldown) and isFlippable())
	{
		audio_play_sound(sdDash, 8, false, 2);
		
		
		flipped *=-1;
	
		pos_y += flipped*abs(sprite_height);
		spd_y = bounce*flipped;
		
	
		if (current_state == player_states.dash_peak or current_state == player_states.dash_start)
		{
			spd_y += bounce*5*flipped	
		}
		
		if (current_state != player_states.dash_peak)
		{
			dash_cooldown = 0;
		}
		
		if (sign(momentum_tracker.mom_y)==flipped){
			spd_y  += momentum_tracker.mom_y;
			
		}
		//spd_x += momentum_tracker.mom_x
		
		current_state = player_states.jumping;
		full_hop_timer = 0;
		
		tp_cooldown = tp_cooldown_max;
			
		flip_buffer = 0;
		
		curr_jumps = max_jumps-1;
		coyote_timer = 0;
		
		
		if (flipped)
		{
			image_yscale = -1;
			curr_shader = invertColor	
			
		}


		else
		{
			image_yscale = 1;
			curr_shader = defaultShader
		}



		script_execute(playEffect,pos_x, pos_y, sTPeffect, flipped);
	
		/*play flipped effect */
		var temp = curr_solid;
		curr_solid = opposite_solid;
		opposite_solid = temp;
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
			dash_cooldown = 0;
			audio_play_sound(sdJump, 5, false);
			
			sprite_index = sPlayerJump;
			next_sprite = sPlayerJump;
			current_state = player_states.jumping;
			full_hop_timer = full_hop_timer_max;
			//regular jump
			spd_y  = (jump_height*flipped);
			//double jump
			if (curr_jumps != max_jumps)
			{
				spd_y *= jump_decrease_cons;	
			}
			spd_x = spd_x + (run_jump_spd_bonus*sign(spd_x));
			//momentum jump
			if (isGrounded()){
				if (abs(momentum_tracker.mom_y)==flipped){
					spd_y  = (jump_height*flipped)+momentum_tracker.mom_y;
				}
				spd_x = momentum_tracker.mom_x + (run_jump_spd_bonus*sign(spd_x));
			}
			
		
			
			
			curr_grav = 0;
			jump_buffer = 0;
			curr_jumps--;
			
			/*
			if(momentum_y_timer)
			{
				spd_y += momentum_y;
			}
			if(momentum_x_timer)
			{
				spd_x += momentum_x;
			}
			*/
			
			/*play jump particles */
			script_execute(playEffect,pos_x, pos_y, sJumpEffect, flipped, image_xscale);
		}
	else if (jump_key){
		jump_buffer = jump_buffer_max;	
	}
}

dash = function()
{
	if (dash_key and !dash_cooldown)
	{
		audio_play_sound(sdDash, 8, false);
		current_state = player_states.dash_start;
		dash_cooldown = dash_cooldown_max;
		
		
	}
}

/*collision handling function
game maker doesn't really support parametrized function pointers, so i utilitze a local method with a switch statement
function is passed a number from an enumerator, runs a switch statement 
to execute the collision handling code based on the value pased*/

/*call this function upon dying, should restart level ad play dying/respawning animations*/
playDeath = function()
{
	game_restart();	
}

uncrouchable = function()
{
	
	var collision_list = ds_list_create();
	var curr_collider;
	var count = instance_place_list(pos_x, pos_y + flipped*10, oSolid, collision_list, false );
	for(var i = 0; i < count; i++)
	{
		curr_collider = ds_list_find_value(collision_list, i);
		if(curr_collider.collidable == true and curr_collider.flipped == flipped)
					{
					ds_list_destroy(collision_list);
					return false;
					}
	}
	
	ds_list_clear(collision_list);
	return true;
}