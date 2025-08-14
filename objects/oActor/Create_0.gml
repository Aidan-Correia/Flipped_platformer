//initialize valuess
pos_x = x;
pos_y = y;

start_x = x;
start_y = y;

spd_x = 0;
spd_y = 0;

x_remainder = 0;
y_remainder = 0;

col_handler_x = nullCollision;
col_handler_y = nullCollision;


curr_solid = oSolidUnflipped;
opposite_solid = oSolidFlipped;
 
climb_height = 0;
bonk_buffer = 0;


default_grav = 1;
base_grav = 1;

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


//returns true if we are "riding" the given instance, matters for moving platforms as they will "carry" us if they do not move into us
isRiding = function(solidInstance)
{
	if((place_meeting(pos_x, pos_y - flipped, solidInstance)) and (solidInstance.flipped == flipped))
	{
		return true;
	}
	return false;
}
isGrounded = function()
{
	
	return !checkLocation(pos_x,pos_y-flipped,oSolid);
}

isGroundedOffset = function(x_offset, y_offset)
{
	return !checkLocation(pos_x+x_offset,y_offset+pos_y-flipped,oSolid);
	
}
isFlippable = function()
{
	
	
	return (!checkLocation(pos_x,pos_y-(flipped),curr_solid) and checkLocationFlipped(pos_x,pos_y-(flipped*abs(sprite_height)),oSolid))
	
	
	
}


checkLocation = function(x_loc,y_loc, o_type)
{
	var collision_list = ds_list_create();
	var num = instance_place_list(x_loc,y_loc,o_type,collision_list,false);
	for(var i = 0; i < num; i += 1)
	{
		if (ds_list_find_value(collision_list,i).collidable == true and ds_list_find_value(collision_list,i).flipped == flipped)
		{
			ds_list_destroy(collision_list);
			return false;
		}
	}
	ds_list_destroy(collision_list);
	return true;
}

checkLocationFlipped = function(x_loc,y_loc, o_type)
{
	var collision_list = ds_list_create();
	var num = instance_place_list(x_loc,y_loc,o_type,collision_list,false);
	for(var i = 0; i < num; i += 1)
	{
		if (ds_list_find_value(collision_list,i).collidable == true and ds_list_find_value(collision_list,i).flipped != flipped)
		{
			ds_list_destroy(collision_list);
			return false;
		}
	}
	ds_list_destroy(collision_list);
	return true;
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
		
		
		
		while (move != 0)
		{
			
			if checkLocation(pos_x+step,pos_y,oSolid)
			{
				pos_x += step;
				move -= step;
			}
			else
			{
				if (isGrounded() and checkLocation(pos_x+step,pos_y+(flipped*climb_height),oSolid))
				{
					pos_y += (flipped*climb_height);
					pos_x += step
					move -= step;
				}
				else
				{
					move = 0;
					script_execute(collision_type,self);
				}
			}
				
				
		}
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
	
		while (move != 0)
		{
			
			
			if checkLocation(pos_x,pos_y+step,oSolid)
			{
				pos_y += step;
				move -= step;
			}
			else
			{
				if (step*flipped > 0)
				{
					if checkLocation(pos_x+bonk_buffer,pos_y+step,oSolid)
					{
						pos_x += bonk_buffer;
						pos_y += step
						move -= step;
					}
					
					else if checkLocation(pos_x-bonk_buffer,pos_y+step,oSolid)
					{
						pos_x -= bonk_buffer;
						pos_y += step
						move -= step;
					}
					else
					{
						move = 0;	
						script_execute(collision_type,self);
					}
				}
				else
				{
					move = 0;	
					script_execute(collision_type,self);
				}
			}
				
		}
	
	}

	
}


moveSelf = function(x_move, y_move)
{
	
	var dtime = global.dtime_constant;
	moveX(x_move*dtime, col_handler_x);
	moveY(y_move*dtime, col_handler_y);


}
