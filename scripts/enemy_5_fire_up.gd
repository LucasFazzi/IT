extends RigidBody2D

var enemy_5 = global.enemy_5
var player = global.player
var speed = 2
var xpos = Vector2()
var ypos = Vector2()

func _ready():
	xpos = global_position.x 
	ypos = global_position.y
	get_node("enemy_5_fire_area_hit").add_to_group("fire_5")
	hide()

func _physics_process(delta):
	shoot_at_mouse_5_up(delta)

func shoot_at_mouse_5_up(delta):
	global_position.x = xpos 
	global_position.y -= 3

func _on_enemy_5_fire_area_hit_area_entered(area):
	if area.is_in_group("enemy_5_hit"):
		null
	if area.is_in_group("enemy_5_hit_2"):
		null
	else:
		destroy_fire()

func destroy_fire():
	get_node("enemy_5_fire_up_sprite").hide()
	get_node("enemy_5_fire_up_destroyed").play("default")

func _on_timer_shoot_enemy_5_up_timeout():
	destroy_fire()

func _on_enemy_5_fire_up_body_entered(body):
	destroy_fire()

func _on_enemy_5_fire_up_destroyed_animation_finished():
	queue_free()