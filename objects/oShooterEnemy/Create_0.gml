/// @description Insert description here
// You can write your code in this editor
event_inherited()
pos_x = x 
pos_y = y 

curr_state = shooter_states.idle
startup_frames = 24;

unfired = true

enum shooter_states
{
	idle = 0,
	shooting = 1,
	waiting = 2
}

executeStep = function()
{
	switch (curr_state)	
	{
		case shooter_states.idle:
			idleStateStep();
			break;
		case shooter_states.shooting:
			shootingStateStep();
			break;
		case shooter_states.waiting:
			waitingStateStep();
			break;
	}
}

inSightline = function(obj)
{
	if ((self.flipped == obj.flipped) and oCamera.onScreen(obj.pos_x,obj.pos_y))
	{
		return true
	}
}

idleStateStep = function()
{
	image_speed = 0
	
	
	if inSightline(oPlayer)
	{
		image_index = 1
		alarm[0] = startup_frames
		curr_state = shooter_states.waiting
	
	}
	else
	{
		image_index = 0	
	}
	
	
}

shootingStateStep = function()
{
	image_speed = 1
	
	
	if (floor(image_index) == 6) and unfired
	{
		unfired = false
		with(instance_create_layer(pos_x, pos_y+(flipped*5), "enemies", oShooterProjectile, 
		{
			flipped : flipped,
			
		}))
		{
			spd_y = flipped*max_spd
			spd_x = sign(target.pos_x-pos_x)
			parent_shooter = other	
		}
			
	}

	
}

waitingStateStep = function()
{
	image_speed = 0;
	
}