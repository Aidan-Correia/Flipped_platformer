event_inherited();

/*call this function upon dying, should restart level ad play dying/respawning animations*/
playDeath = function()
{
	script_execute(playEffect, pos_x, pos_y, myDeathEffect, flipped);
	instance_destroy(self);	
}