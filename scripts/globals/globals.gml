// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function initializeActorFlipped(obj,fl)
{
	
		if fl
		{
			obj.image_yscale = -1
			obj.curr_shader = invertColor
			obj.flipped = fl
			obj.curr_solid = oSolidFlipped
			obj.opposite_solid  = oSolidUnflipped
		}
		else
		{
			obj.image_xscale = 1
			obj.curr_shader = defaultShader
			obj.flipped = -1
			obj.curr_solid = oSolidUnflipped
			obj.opposite_solid  = oSolidFlipped
		}
	

}

function initializeSolidFlipped(obj,fl)
{
	
		if fl
		{
			obj.image_yscale = -1
			obj.curr_shader = invertColor
			obj.flipped = fl
		}
		else
		{
			obj.image_xscale = 1
			obj.curr_shader = defaultShader
			obj.flipped = -1
		}
	

}

