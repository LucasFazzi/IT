extends Node2D

var door_3_1
var door_3_1_2
var door_3_2
var door_3_3
var door_3_3_2
var key_3_1
var key_3_2
var key_3_3
signal key_3_1
signal key_3_2
signal key_3_3

func _ready():
	door_3_1 = get_node("door_3_1")
	door_3_1_2 = get_node("door_3_1_2")
	door_3_2 = get_node("door_3_2")
	door_3_3 = get_node("door_3_3")
	door_3_3_2 = get_node("door_3_3_2")
	key_3_1 = get_node("key_3_1")
	key_3_2 = get_node("key_3_2")
	key_3_3 = get_node("key_3_3")
	door_3_1.add_to_group("door_3_1")
	door_3_1_2.add_to_group("door3_1")
	door_3_2.add_to_group("door_2_1")
	door_3_3.add_to_group("door_3_3")
	door_3_3_2.add_to_group("door_3_3")
	key_3_1.add_to_group("key_3_1")
	key_3_2.add_to_group("key_3_2")
	key_3_3.add_to_group("key_3_3")

func _on_key_3_1_area_entered(area):
	if area.is_in_group("player_hit"):
		get_key_3_1()
	else:
		null

func _on_key_3_2_area_entered(area):
	if area.is_in_group("player_hit"):
		get_key_3_2()
	else:
		null

func _on_key_3_3_area_entered(area):
	if area.is_in_group("player_hit"):
		get_key_3_3()
	else:
		null

func get_key_3_1():
	door_3_1.queue_free()
	door_3_1_2.queue_free()
	key_3_1.queue_free()

func get_key_3_2():
	door_3_2.queue_free()
	key_3_2.queue_free()

func get_key_3_3():
	door_3_3.queue_free()
	door_3_3_2.queue_free()
	key_3_3.queue_free()

func _on_exit_1_area_entered(area):
	if area.is_in_group("player_hit"):
		get_tree().change_scene("res://scenes/level4.tscn")
	else:
		null



