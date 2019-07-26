extends Node2D

var door_1_1
var door_1_2
var key_1_1
var key_1_2

func _ready():
	door_1_1 = get_node("door_1_1")
	door_1_2 = get_node("door_1_2")
	key_1_1 = get_node("key_1_1")
	key_1_2 = get_node("key_1_2")
	door_1_1.add_to_group("door_1_1")
	door_1_2.add_to_group("door_1_2")
	key_1_1.add_to_group("key_1_1")
	key_1_2.add_to_group("key_1_2")

func _on_key_1_area_entered(area):
	if area.is_in_group("player_hit"):
		get_key_1_1()
	else:
		null

func _on_key_2_area_entered(area):
	if area.is_in_group("player_hit"):
		get_key_1_2()
	else:
		null

func get_key_1_1():
	door_1_1.queue_free()
	key_1_1.queue_free()

func get_key_1_2():
	door_1_2.queue_free()
	key_1_2.queue_free()

func _on_exit_1_area_entered(area):
	if area.is_in_group("player_hit"):
		get_tree().change_scene("res://scenes/level2.tscn")
	else:
		null