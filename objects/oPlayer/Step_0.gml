step_sound_timer += 1;

step_sound_timer = step_sound_timer%35;

if (step_sound_timer == 0 and current_state = player_states.walking){
	audio_play_sound(choose(sdStep1, sdStep2, sdStep3, sdStep4, sdStep5), 1, false);	

}


getInput();



executeState();
timerUpdate();

var move = right_key-left_key;

if (move != 0)
{
	image_xscale = sign(move)*x_squish_amount;	
}
else
{
	image_xscale = sign(image_xscale)*x_squish_amount;	
}

image_yscale = sign(image_yscale)*y_squish_amount


if (paralyzed)
{
	spd_x = 0;
}
moveSelf(spd_x, spd_y);
