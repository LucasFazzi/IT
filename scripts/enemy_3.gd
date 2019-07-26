extends KinematicBody2D

const SPEED = 1.5

onready var player = get_parent().get_node("player") 
onready var enemy_3_FOV = false
onready var enemy_3_fire = false
onready var clock_shoot = 350
onready var enemy_3_notifier = false
onready var enemy_3
onready var entered = false

var ENEMY_3_LIFE = 100
var RAND_SPEED = 0
var enemy_3_velocity = Vector2()
var random_direction_enemy_3 = 0
var enemy_3_colliding_wall = 1
var timer_enemy_3 = 250
var timer_2_enemy_3 = 100
var timer_enemy_3_wall = 0

func _ready():
	global.enemy_3 = self
	enemy_3 = global.enemy_3
	get_node("enemy_3_fov").add_to_group("fov_enemies")
	get_node("enemy_3_hit").add_to_group("enemy_3_hit")
	get_node(".").add_to_group("enemies")
	randomize()
	RAND_SPEED = randi()%5+1

func _on_entered_screen_screen_entered():
	entered = true

func _on_enemy_3_fov_body_entered(body):
	if body == player:
		enemy_3_FOV = true
		enemy_3_fire = true
	else:
		null
func _on_enemy_3_notifier_screen_entered():
	enemy_3_notifier = true

func _on_enemy_3_fov_body_exited(body):
	if body == player:
		enemy_3_FOV = false
		enemy_3_fire = false
	else:
		null

func _process(delta):
	timer_enemy_3 -= 1
	if timer_enemy_3 == 0:
		enemy_3_colliding_wall = 1
		randomize()
		random_direction_enemy_3 = randi()%4+1
		timer_enemy_3 = 250

func _physics_process(delta):
	if get_node("enemy_3_raycast_down").is_colliding():
		timer_enemy_3_wall += 1
		enemy_3_colliding_wall = 2
	if not get_node("enemy_3_raycast_down").is_colliding():
		timer_2_enemy_3 -= 1

	if get_node("enemy_3_raycast_up").is_colliding():
		timer_enemy_3_wall += 1
		enemy_3_colliding_wall = 3
	if not get_node("enemy_3_raycast_up").is_colliding():
		timer_2_enemy_3 -= 1

	if get_node("enemy_3_raycast_right").is_colliding():
		timer_enemy_3_wall += 1
		enemy_3_colliding_wall = 4
	if not get_node("enemy_3_raycast_right").is_colliding():
		timer_2_enemy_3 -= 1

	if get_node("enemy_3_raycast_left").is_colliding():
		timer_enemy_3_wall += 1
		enemy_3_colliding_wall = 5
	if not get_node("enemy_3_raycast_left").is_colliding():
		timer_2_enemy_3 -= 1

	if timer_2_enemy_3 == 0:
		enemy_3_colliding_wall = 1

	if timer_enemy_3_wall >= 250:
		timer_enemy_3_wall = 0

	if enemy_3_FOV == true and entered == true:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_collide(vec_to_player * RAND_SPEED * delta)
		play_enemy_3_animation_pos_FOV()

	if enemy_3_fire == true and enemy_3_notifier == true:
		clock_shoot -= 35
	else:
		null
	if clock_shoot == 0:
		clock_shoot += 350
		enemy_3_shoot()

	if enemy_3_FOV == false and entered == true:
		play_enemy_3_animation_pos()
		if enemy_3_colliding_wall == 1:
			update_enemy_3_path_without_colliding()
		if enemy_3_colliding_wall == 2:
			enemy_3_raycast_down_path()
		if enemy_3_colliding_wall == 3:
			enemy_3_raycast_up_path()
		if enemy_3_colliding_wall == 4:
			enemy_3_raycast_right_path()
		if enemy_3_colliding_wall == 5:
			enemy_3_raycast_left_path()

func play_enemy_3_animation_pos_FOV():
	if player.position.y >= position.y:
		get_node("enemy_3_sprite").play("walking_front")
	if player.position.y <= position.y:
			if abs(player.position.y - position.y) < 40:
				if player.position.x > position.x:
					get_node("enemy_3_sprite").play("walking_right")
				if player.position.x < position.x:
					get_node("enemy_3_sprite").play("walking_left")
			else: get_node("enemy_3_sprite").play("walking_back")

func play_enemy_3_animation_pos():
	if enemy_3_velocity.x > 0:
		get_node("enemy_3_sprite").play("walking_right")
	if enemy_3_velocity.x < 0:
		get_node("enemy_3_sprite").play("walking_left")
	if enemy_3_velocity.y > 0:
		get_node("enemy_3_sprite").play("walking_front")
	if enemy_3_velocity.y < 0:
		get_node("enemy_3_sprite").play("walking_back")

func update_enemy_3_path_without_colliding():
	if random_direction_enemy_3 == 1:
		enemy_3_colliding_wall = 1
		enemy_3_velocity.y -= 0.06
		enemy_3_velocity.x = 0 
		move_and_slide(enemy_3_velocity * SPEED).normalized()

	if random_direction_enemy_3 == 2:
		enemy_3_colliding_wall = 1
		enemy_3_velocity.x += 0.06 
		enemy_3_velocity.y = 0
		move_and_slide(enemy_3_velocity * SPEED).normalized()

	if random_direction_enemy_3 == 3:
		enemy_3_colliding_wall = 1
		enemy_3_velocity.x -= 0.06 
		enemy_3_velocity.y = 0
		move_and_slide(enemy_3_velocity * SPEED).normalized()

	if random_direction_enemy_3 == 4:
		enemy_3_colliding_wall = 1
		enemy_3_velocity.y += 0.06 
		enemy_3_velocity.x = 0
		move_and_slide(enemy_3_velocity * SPEED).normalized()

func enemy_3_raycast_down_path():
	if timer_enemy_3_wall >= 60:
			enemy_3_velocity.x = 0
			enemy_3_velocity.y -= 0.06
			move_and_slide(enemy_3_velocity * SPEED).normalized()
	if timer_enemy_3_wall < 60:
		enemy_3_velocity.x = 0 
		enemy_3_velocity.y -= 0.06
		move_and_slide(enemy_3_velocity * SPEED).normalized()

func enemy_3_raycast_up_path():
	if timer_enemy_3_wall >= 60:
			enemy_3_velocity.x = 0
			enemy_3_velocity.y += 0.06
			move_and_slide(enemy_3_velocity * SPEED).normalized()
	if timer_enemy_3_wall < 60:
		enemy_3_velocity.x = 0 
		enemy_3_velocity.y += 0.06
		move_and_slide(enemy_3_velocity * SPEED).normalized()

func enemy_3_raycast_right_path():
	if timer_enemy_3_wall >= 60:
			enemy_3_velocity.x -= 0.06
			enemy_3_velocity.y = 0
			move_and_slide(enemy_3_velocity * SPEED).normalized()
	if timer_enemy_3_wall < 60:
		enemy_3_velocity.x -= 0.06
		enemy_3_velocity.y = 0
		move_and_slide(enemy_3_velocity * SPEED).normalized()

func enemy_3_raycast_left_path():
	if timer_enemy_3_wall >= 60:
			enemy_3_velocity.x += 0.06
			enemy_3_velocity.y = 0
			move_and_slide(enemy_3_velocity * SPEED).normalized()
	if timer_enemy_3_wall < 60:
		enemy_3_velocity.x += 0.06 
		enemy_3_velocity.y = 0
		move_and_slide(enemy_3_velocity * SPEED).normalized()

func _on_enemy_3_hit_area_entered(area):
	if area.is_in_group("bullet_1_hit_group"):
		ENEMY_3_LIFE -= 35
	if ENEMY_3_LIFE <= 0:
		destroy_enemy_3()
	else:
		null

func destroy_enemy_3():
	queue_free()

func enemy_3_shoot():
	var fire = preload("res://scenes/enemy_3_fire.tscn").instance()
	get_parent().add_child(fire)
	fire.show()
	fire.shoot_at_mouse_3(self.global_position)


