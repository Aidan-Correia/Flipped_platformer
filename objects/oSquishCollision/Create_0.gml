execute = function(actor)
{
	if (object_is_ancestor(actor.object_index,oActorKillable))
	{
		actor.playDeath();
	}
	return;
}