function nullCollision(actor){
	return;
}

function squishCollision(actor){
	if (object_is_ancestor(actor.object_index,oActorKillable))
	{
		actor.playDeath();
	}
	return;
}

function waddleCollisionX(actor){
		actor.dir *= -1;
		actor.image_xscale *= -1;
}

function waddleCollisionY(actor){
		actor.spd_y = 0;
}