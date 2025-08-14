// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function playEffect(posx, posy, sprite, fl=-1, x_sc = 1, y_scl = -1*fl)
{
	with(instance_create_layer(posx, posy, "effects", oEffects,
	{
		flipped : fl,
		sprite_index : sprite
		
	}
	))
	{
		image_xscale = x_sc;
		image_yscale = y_scl;
	}
	
			
	
		
}

