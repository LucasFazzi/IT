extends RigidBody2D

func _ready():
	hide()

func shoot_at_direction_right(start_pos):
	self.global_position = start_pos
	self.linear_velocity.x += 1000
	get_node("bullet_1_hit").add_to_group("bullet_1_hit_group")

func shoot_at_direction_left(start_pos):
	self.global_position = start_pos
	self.linear_velocity.x -= 1000
	get_node("bullet_1_hit").add_to_group("bullet_1_hit_group")

func shoot_at_direction_up(start_pos):
	self.global_position = start_pos
	self.linear_velocity.y -= 1000
	get_node("bullet_1_hit").add_to_group("bullet_1_hit_group")

func shoot_at_direction_down(start_pos):
	self.global_position = start_pos
	self.linear_velocity.y += 1000
	get_node("bullet_1_hit").add_to_group("bullet_1_hit_group")

func shoot_at_direction_dig_right_up(start_pos):
	self.global_position = start_pos
	self.linear_velocity.y -= 1000
	self.linear_velocity.x += 1000
	get_node("bullet_1_hit").add_to_group("bullet_1_hit_group")

func shoot_at_direction_dig_left_up(start_pos):
	self.global_position = start_pos
	self.linear_velocity.y -= 1000
	self.linear_velocity.x -= 1000
	get_node("bullet_1_hit").add_to_group("bullet_1_hit_group")

func shoot_at_direction_dig_left_down(start_pos):
	self.global_position = start_pos
	self.linear_velocity.y += 1000
	self.linear_velocity.x -= 1000
	get_node("bullet_1_hit").add_to_group("bullet_1_hit_group")

func shoot_at_direction_dig_right_down(start_pos):
	self.global_position = start_pos
	self.linear_velocity.y += 1000
	self.linear_velocity.x += 1000
	get_node("bullet_1_hit").add_to_group("bullet_1_hit_group")

func _on_bullet_1_hit_area_entered(area):
	if area.is_in_group("player_hit"):
		null
	if area.is_in_group("fov_enemies"):
		null
	if area.is_in_group("enemy_1_hit"):
		queue_free()
	if area.is_in_group("enemy_1_modified_hit"):
		queue_free()
	if area.is_in_group("enemy_2_hit"):
		queue_free()
	if area.is_in_group("enemy_3_hit"):
		queue_free()
	if area.is_in_group("enemy_4_hit"):
		queue_free()
	if area.is_in_group("enemy_2_fire_group"):
		queue_free()
	if area.is_in_group("enemy_3_fire_group"):
		null

func _on_bullet_1_timer_timeout():
	queue_free()