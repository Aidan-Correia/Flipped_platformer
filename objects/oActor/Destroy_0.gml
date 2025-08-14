/// @description Insert description here
// You can write your code in this editor

array_delete(global.actor_list,array_find_index(global.actor_list,function(_element){
        return (_element.id == self.id);}), 1);
