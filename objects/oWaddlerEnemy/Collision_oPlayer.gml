/// @description Insert description here
// You can write your code in this editor


if (oPlayer.flipped == flipped)
{
		if (sign(oPlayer.spd_y) != flipped*-1)
		{
			oPlayer.playDeath();
		}
		else
		{
			playDeath();	
		}
}



