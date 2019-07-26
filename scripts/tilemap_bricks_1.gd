extends Node2D

func _ready():
	get_node("walls_sprite_1/walls_area_1/walls_collision_1").add_to_group("walls")
	get_node("walls_sprite_2/walls_area_2/walls_collision_2").add_to_group("walls")
