
var target_speed = dir*walk_speed;

spd_x = sign(target_speed-spd_x)*.3

spd_y -= flipped*base_grav;


moveSelf();

