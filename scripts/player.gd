extends KinematicBody2D

signal shoot_1
signal shield_1
signal enemy_1_hit
signal enemy_1_modified_hit
signal enemy_2_hit
signal enemy_3_hit
signal enemy_4_hit
signal enemy_5_hit
signal enemy_2_fire_hit
signal enemy_3_fire_hit
signal enemy_5_fire_hit

export (int) var speed = 380
var WAKEOMETER = 28000
var PLAYER_AMMUNITION = 250
var ammo
var health
var velocity = Vector2()

func _ready():
	get_node("player_hit").add_to_group("player_hit")
	get_node("player_catch1").add_to_group("player_catches")
	get_node("player_catch2").add_to_group("player_catches")
	global.player = self

func _process(delta):
	WAKEOMETER -=1

	if WAKEOMETER <= 0:
		game_over()

	if velocity.x >= 1 and velocity.y == 0:
		get_node("player_sprite").play("walk_right")
	if velocity.x <= 1 and velocity.y == 0:
		get_node("player_sprite").play("walk_left")
	if velocity.y >= 1 and velocity.x == 0:
		get_node("player_sprite").play("walk_front")
	if velocity.y <= 1 and velocity.x == 0:
		get_node("player_sprite").play("walk_back")
	if velocity.y == 0 and velocity.x == 0:
		get_node("player_sprite").play("idle")

func _physics_process(delta):
	get_input()
	move_and_slide(velocity)
	shoot1()
	shield()

func get_input():
	velocity = Vector2()

	if Input.is_action_pressed('right'):
		velocity.x += 1

	if Input.is_action_pressed('left'):
		velocity.x -= 1

	if Input.is_action_pressed('down'):
		velocity.y += 1

	if Input.is_action_pressed('up'):
		velocity.y -= 1

	velocity = velocity.normalized() * speed  


func shoot1():
	if velocity.x > 0 and velocity.y == 0 and PLAYER_AMMUNITION >= 1 and Input.is_action_just_pressed('shoot'):
		var bullet = preload("res://scenes/bullet_1.tscn").instance()
		get_parent().add_child(bullet)
		bullet.show()
		bullet.shoot_at_direction_right(get_node("shot_right_spawn").global_position)
		PLAYER_AMMUNITION -= 1
		ammo = PLAYER_AMMUNITION
		get_node("shot_1_sfx").play()
		emit_signal("shoot_1")
	if velocity.x < 0 and velocity.y == 0 and PLAYER_AMMUNITION >= 1 and Input.is_action_just_pressed('shoot'):
		var bullet = preload("res://scenes/bullet_1.tscn").instance()
		get_parent().add_child(bullet)
		bullet.show()
		bullet.shoot_at_direction_left(get_node("shot_left_spawn").global_position)
		PLAYER_AMMUNITION -= 1
		ammo = PLAYER_AMMUNITION
		get_node("shot_1_sfx").play()
		emit_signal("shoot_1")
	if velocity.y < 0 and velocity.x == 0 and PLAYER_AMMUNITION >= 1 and Input.is_action_just_pressed('shoot'):
		var bullet = preload("res://scenes/bullet_1.tscn").instance()
		get_parent().add_child(bullet)
		bullet.show()
		bullet.shoot_at_direction_up(get_node("shot_up_spawn").global_position)
		PLAYER_AMMUNITION -= 1
		ammo = PLAYER_AMMUNITION
		get_node("shot_1_sfx").play()
		emit_signal("shoot_1")
	if velocity.y > 0 and velocity.x == 0 and PLAYER_AMMUNITION >= 1 and Input.is_action_just_pressed('shoot'):
		var bullet = preload("res://scenes/bullet_1.tscn").instance()
		get_parent().add_child(bullet)
		bullet.show()
		bullet.shoot_at_direction_down(get_node("shot_down_spawn").global_position)
		PLAYER_AMMUNITION -= 1
		ammo = PLAYER_AMMUNITION
		get_node("shot_1_sfx").play()
		emit_signal("shoot_1")
	if velocity.x > 0 and velocity.y < 0 and PLAYER_AMMUNITION >= 1  and Input.is_action_just_pressed('shoot'):
		var bullet = preload("res://scenes/bullet_1.tscn").instance()
		get_parent().add_child(bullet)
		bullet.show()
		bullet.shoot_at_direction_dig_right_up(self.global_position)
		PLAYER_AMMUNITION -= 1
		ammo = PLAYER_AMMUNITION
		get_node("shot_1_sfx").play()
		emit_signal("shoot_1")
	if velocity.x < 0 and velocity.y < 0 and PLAYER_AMMUNITION >= 1 and Input.is_action_just_pressed('shoot'):
		var bullet = preload("res://scenes/bullet_1.tscn").instance()
		get_parent().add_child(bullet)
		bullet.show()
		bullet.shoot_at_direction_dig_left_up(self.global_position)
		PLAYER_AMMUNITION -= 1
		ammo = PLAYER_AMMUNITION
		get_node("shot_1_sfx").play()
		emit_signal("shoot_1")
	if velocity.x < 0 and velocity.y > 0 and PLAYER_AMMUNITION >= 1 and Input.is_action_just_pressed('shoot'):
		var bullet = preload("res://scenes/bullet_1.tscn").instance()
		get_parent().add_child(bullet)
		bullet.show()
		bullet.shoot_at_direction_dig_left_down(self.global_position)
		PLAYER_AMMUNITION -= 1
		ammo = PLAYER_AMMUNITION
		get_node("shot_1_sfx").play()
		emit_signal("shoot_1")
	if velocity.x > 0 and velocity.y > 0 and PLAYER_AMMUNITION >= 1 and Input.is_action_just_pressed('shoot'):
		var bullet = preload("res://scenes/bullet_1.tscn").instance()
		get_parent().add_child(bullet)
		bullet.show()
		bullet.shoot_at_direction_dig_right_down(self.global_position)
		PLAYER_AMMUNITION -= 1
		ammo = PLAYER_AMMUNITION
		get_node("shot_1_sfx").play()
		emit_signal("shoot_1")
	if velocity.x == 0 and velocity.y == 0 and PLAYER_AMMUNITION >= 1 and Input.is_action_just_pressed('shoot'):
		null

func shield():
	if Input.is_action_just_pressed('shield') and PLAYER_AMMUNITION >= 1:
		get_node("animation_trigger_shield").play("animation_shield")
		PLAYER_AMMUNITION -= 45
		emit_signal("shield_1")
	else:
		null

func _on_player_hit_area_entered(area):
	if area.is_in_group("enemy_1_hit"):
		player_hit_enemy()
		emit_signal("enemy_1_hit")
		get_node("animation_trigger_enemies").play("enemies_backstep_attack")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	if area.is_in_group("enemy_1_modified_hit"):
		player_hit_enemy()
		emit_signal("enemy_1_modified_hit")
		get_node("animation_trigger_enemies").play("enemies_backstep_attack")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	if area.is_in_group("enemy_2_hit"):
		player_hit_enemy()
		emit_signal("enemy_2_hit")
		get_node("animation_trigger_enemies").play("enemies_backstep_attack")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	if area.is_in_group("enemy_3_hit"):
		player_hit_enemy()
		emit_signal("enemy_3_hit")
		get_node("animation_trigger_enemies").play("enemies_backstep_attack")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	if area.is_in_group("enemy_4_hit"):
		player_hit_enemy()
		emit_signal("enemy_4_hit")
		get_node("animation_trigger_enemies").play("enemies_backstep_attack")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	if area.is_in_group("enemy_2_fire_group"):
		player_hit_fire()
		emit_signal("enemy_2_fire_hit")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	if area.is_in_group("enemy_3_fire_group"):
		player_hit_fire_2()
		emit_signal("enemy_3_fire_hit")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	if area.is_in_group("enemy_5_hit"):
		player_hit_enemy()
		emit_signal("enemy_5_hit")
		get_node("animation_trigger_enemies").play("enemies_backstep_attack")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	if area.is_in_group("fire_5"):
		player_hit_fire_5()
		emit_signal("enemy_5_fire_hit")
		get_node("animation_hit").play("hit_anim")
		get_node("player_hit_sfx").play()
	else:
		null

func player_hit_enemy():
	WAKEOMETER -= 7000
	health = WAKEOMETER

func player_hit_fire():
	WAKEOMETER -= 14000
	health = WAKEOMETER

func player_hit_fire_2():
	WAKEOMETER -= 280
	health = WAKEOMETER

func player_hit_fire_5():
	WAKEOMETER -= 14000
	health = WAKEOMETER

func game_over():
	get_tree().reload_current_scene()

