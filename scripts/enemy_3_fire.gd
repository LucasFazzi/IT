extends RigidBody2D

var speed = 400
onready var enemy_3_fire = self
onready var player = global.player

func _ready():
	hide()

func shoot_at_mouse_3(start_pos):
	self.global_position = start_pos
	var direction = (player.position - start_pos).normalized()
	self.linear_velocity = direction * speed
	get_node("enemy_3_fire_area_hit").add_to_group("enemy_3_fire_group")

func _on_enemy_3_fire_area_hit_area_entered(area):
	if area.is_in_group("enemy_3_hit"):
		null
	if area.is_in_group("bullet_1_hit_group"):
		null
	else:
		destroy_fire()

func _on_enemy_3_fire_timer_timeout():
	destroy_fire()

func destroy_fire():
	queue_free()