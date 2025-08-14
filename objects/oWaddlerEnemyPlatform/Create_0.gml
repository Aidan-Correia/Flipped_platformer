/// @description Insert description here
// You can write your code in this editor
event_inherited();

pos_x = x;
pos_y = y;



dir = -1;
image_xscale = dir;
walk_speed = 1;

default_grav = .22;
base_grav = .22;
spd_x = 0;
spd_y = 0;


//initialize valuess


start_x = x;
start_y = y;


pos_x_track = pos_x;
pos_y_track = pos_y;

x_remainder = 0;
y_remainder = 0;

col_handler_x = waddleCollisionX;
col_handler_y = waddleCollisionY;





checkLocation = function(x_loc,y_loc, o_type)
{
	var collision_list = ds_list_create();
	var num = instance_place_list(x_loc,y_loc,o_type,collision_list,false);
	for(var i = 0; i < num; i += 1)
	{
		if (ds_list_find_value(collision_list,i).collidable == true and ds_list_find_value(collision_list, i).flipped != -1*flipped)
		{
			ds_list_destroy(collision_list);
			return false;
		}
	}
	ds_list_destroy(collision_list);
	return true;
}
//moves player given amount in respective direction
actorMoveX = function(move_amount, collision_type)
{
	
	x_remainder += move_amount;
	var move = round(x_remainder);
	
	if (move != 0)
	{
		x_remainder -= move;
		var step = sign(move);
		
		
		
		while (move != 0)
		{
			
			if checkLocation(pos_x_track+step,pos_y_track,oObstacle)
			{
				pos_x_track += sign(move);
				move -= sign(move);
			}
			else
			{
				move = 0;
				script_execute(collision_type,self);
			}
				
				
		}
	}

	
}

actorMoveY = function(move_amount, collision_type)
{
	y_remainder += move_amount;
	var move = round(y_remainder);
	
	if (move != 0)
	{
		y_remainder -= move;
		var step = sign(move);
	
		while (move != 0)
		{
			
			
			if checkLocation(pos_x_track,pos_y_track+step,oObstacle)
			{
				pos_y_track += step;
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
moveSelf = function()
{
	self.collidable = false;
	pos_x_track = pos_x;
	pos_y_track = pos_y;
	actorMoveX(spd_x*global.dtime_constant, col_handler_x);
	actorMoveY(spd_y*global.dtime_constant, col_handler_y);
	self.collidable = true;
	move((pos_x_track-pos_x)*global.dtime_constant, (pos_y_track-pos_y)*global.dtime_constant);

	

	x = pos_x;
	y = pos_y;

}
