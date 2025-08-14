/// @description Insert description here
// You can write your code in this editor
global.dtime_constant = delta_time/game_get_speed(gamespeed_microseconds);
global.dtime_constant =  clamp(global.dtime_constant, .88,1.12);
global.dtime_constant = 1;

