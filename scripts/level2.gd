extends Node2D

var door_1_1
var door_1_2
var door_2_1
var door_2_2
var key_2_1
var key_2_2
signal key_2_1
signal key_2_2

func _ready():
	door_1_1 = get_node("door_1_1")
	door_1_2 = get_node("door_1_2")
	door_2_1 = get_node("door_2_1")
	door_2_2 = get_node("door_2_2")
	key_2_1 = get_node("key_2_1")
	key_2_2 = get_node("key_2_2")
	door_1_1.add_to_group("door_1")
	door_1_2.add_to_group("door_1")
	door_2_1.add_to_group("door_2")
	door_2_2.add_to_group("door_2")
	key_2_1.add_to_group("key_2_1")
	key_2_2.add_to_group("key_2_2")

func _on_key_2_1_area_entered(area):
	if area.is_in_group("player_hit"):
		get_key_2_1()
	else:
		null

func _on_key_2_2_area_entered(area):
	if area.is_in_group("player_hit"):
		get_key_2_2()
	else:
		null

func get_key_2_1():
	door_1_1.queue_free()
	door_1_2.queue_free()
	key_2_1.queue_free()

func get_key_2_2():
	door_2_1.queue_free()
	door_2_2.queue_free()
	key_2_2.queue_free()

func _on_exit_2_area_entered(area):
	if area.is_in_group("player_hit"):
		get_tree().change_scene("res://scenes/level3.tscn")
	else:
		null




