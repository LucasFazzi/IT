extends RigidBody2D

var speed = 190

onready var player = global.player

func _ready():
	hide()

func shoot_at_mouse_2(start_pos):
		self.global_position = start_pos
		var direction = (player.position - start_pos).normalized()
		self.linear_velocity = direction * speed
		get_node("enemy_2_fire_area_hit").add_to_group("enemy_2_fire_group")

func _on_enemy_2_fire_area_hit_area_entered(area):
	if area.is_in_group("enemy_2_hit"):
		null
	else:
		destroy_fire()

func _on_enemy_2_fire_timer_timeout():
	destroy_fire()

func _on_enemy_2_fire_body_entered(body):
	destroy_fire()

func destroy_fire():
	get_node("enemy_2_fire_sprite").hide()
	get_node("enemy_fire_destoyed").play("default")

func _on_enemy_fire_destoyed_animation_finished():
	queue_free()
