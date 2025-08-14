/// @description Insert description here
// You can write your code in this editor
rider_list = [];
collidable_actor_list = [];

pos_x = x;
pos_y = y;

x_remainder = 0;
y_remainder = 0;

collidable = true;
flipped = -1;

//each time the object is moved, this function is called
//updates current list of riders, as well as the list of collidable actors (based on flip state of actor and this solid)
setCurrLists = function()
{
	if collidable
	{
	for (var i = 0; i < array_length(global.actor_list); i++)
		{
		if global.actor_list[i] != noone
		{
			if(global.actor_list[i].flipped = self.flipped)
			{
				array_push(collidable_actor_list, global.actor_list[i]);
				
				if (global.actor_list[i].isRiding(self))
				{
					
					array_push(rider_list, global.actor_list[i]);	
				}
			}
			}
		}
	}
	else
	{
		collidable_actor_list = [];
		rider_list = [];
	}
}

//move
move = function(x_step, y_step)
{
	x_remainder += x_step;
	y_remainder += y_step;
	
	var move_x = round(x_remainder);
	var move_y = round(y_remainder);
	
	if (move_x != 0 or move_y != 0)
	{
			var was_collidable = collidable;
			setCurrLists();
			
			
			collidable = false; //makes this object uncollidable
			
			if (move_x != 0)
			{
				x_remainder -= move_x
				pos_x += move_x
				 //moving right
				if (move_x > 0)
				{
					for (var i = 0; i < array_length(collidable_actor_list); i++)
					{
						var curr_actor = collidable_actor_list[i]
						if (place_meeting(pos_x,pos_y, curr_actor) and curr_actor.flipped = flipped)
						{
							curr_actor.moveX((bbox_right-curr_actor.bbox_left)+1, squishCollision);
						}
						
						else if (array_contains(rider_list, curr_actor))
						{
							if (curr_actor.spd_x == 0)
							{
								curr_actor.moveX(move_x, nullCollision);
							}
						}
					}
				}
				//moving left
				else
				{
					for (var i = 0; i < array_length(collidable_actor_list); i++)
					{
						var curr_actor = collidable_actor_list[i]
						if (place_meeting(pos_x,pos_y, curr_actor) and curr_actor.flipped = flipped)
						{
							
							curr_actor.moveX((bbox_left-curr_actor.bbox_right)-1, squishCollision);
						}
						
						else if (array_contains(rider_list, curr_actor))
						{
							
							curr_actor.moveX(move_x, nullCollision);
							
						}
					}
				}
			}
			setCurrLists();
			//handle y movement (same as x)
			if (move_y != 0)
			{
				y_remainder -= move_y
				pos_y += move_y
				 //moving up
				if (move_y > 0)
				{
					for (var i = 0; i < array_length(collidable_actor_list); i++)
					{
						var curr_actor = collidable_actor_list[i]
						if (place_meeting(pos_x,pos_y, curr_actor) and curr_actor.flipped = flipped)
						{
							curr_actor.moveY((bbox_top-curr_actor.bbox_bottom)+1, squishCollision);
						}
						
						else if (array_contains(rider_list, curr_actor))
						{
							curr_actor.moveY(move_y, nullCollision);
						}
					}
				}
				//moving down
				else
				{
					for (var i = 0; i < array_length(collidable_actor_list); i++)
					{
						var curr_actor = collidable_actor_list[i]
						if (place_meeting(pos_x,pos_y, curr_actor) and curr_actor.flipped = flipped)
						{
							curr_actor.moveY((bbox_bottom-curr_actor.bbox_top)-1, squishCollision);
						}
						
						else if (array_contains(rider_list, curr_actor))
						{
							curr_actor.moveY(move_y, nullCollision);
						}
					}
				}
			}	
			
			collidable = was_collidable;
			rider_list = [];
			collidable_actor_list = [];
		}	
		
}

moveSelf = function(x_move, y_move)
{
	
	var dtime = global.dtime_constant;
	move(x_move*dtime, y_move*dtime);
	


}