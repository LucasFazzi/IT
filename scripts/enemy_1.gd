extends KinematicBody2D

const SPEED = 5

onready var player = get_parent().get_node("player")
onready var enemy_1_FOV = false
onready var enemy_1
onready var entered = false

var ENEMY_1_LIFE = 100
var RAND_SPEED = 0
var enemy_1_velocity = Vector2()
var random_direction_enemy_1 = 0
var enemy_1_colliding_wall = 1
var timer_enemy_1 = 250
var timer_2_enemy_1 = 100
var timer_enemy_1_wall = 0

func _ready():
	global.enemy_1 = self
	enemy_1 = global.enemy_1
	get_node("fov_enemy_1").add_to_group("fov_enemies")
	get_node("enemy_1_hit").add_to_group("enemy_1_hit")
	get_node(".").add_to_group("enemies")
	randomize()
	RAND_SPEED = randi()%100+50

func _on_screen_notifier_1_screen_entered():
	entered = true

func _on_fov_enemy_1_body_entered(body):
	if body == player:
		enemy_1_FOV = true
	else:
		null
func _on_fov_enemy_1_body_exited(body):
	if body == player:
		enemy_1_FOV = false
	else:
		null

func _process(delta):
	timer_enemy_1 -= 1
	if timer_enemy_1 == 0:
		enemy_1_colliding_wall = 1
		randomize()
		random_direction_enemy_1 = randi()%4+1
		timer_enemy_1 = 250
 
func _physics_process(delta):
	if get_node("enemy_1_raycast_down").is_colliding():
		timer_enemy_1_wall += 1
		enemy_1_colliding_wall = 2
	if not get_node("enemy_1_raycast_down").is_colliding():
		timer_2_enemy_1 -= 1

	if get_node("enemy_1_raycast_up").is_colliding():
		timer_enemy_1_wall += 1
		enemy_1_colliding_wall = 3
	if not get_node("enemy_1_raycast_up").is_colliding():
		timer_2_enemy_1 -= 1

	if get_node("enemy_1_raycast_right").is_colliding():
		timer_enemy_1_wall += 1
		enemy_1_colliding_wall = 4
	if not get_node("enemy_1_raycast_right").is_colliding():
		timer_2_enemy_1 -= 1

	if get_node("enemy_1_raycast_left").is_colliding():
		timer_enemy_1_wall += 1
		enemy_1_colliding_wall = 5
	if not get_node("enemy_1_raycast_left").is_colliding():
		timer_2_enemy_1 -= 1

	if timer_2_enemy_1 == 0:
		enemy_1_colliding_wall = 1

	if timer_enemy_1_wall >= 250:
		timer_enemy_1_wall = 0

	if enemy_1_FOV == true and entered == true:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_collide(vec_to_player * RAND_SPEED * delta)
		play_enemy_1_animation_pos_FOV()

	if enemy_1_FOV == false and entered == true:
		play_enemy_1_animation_pos()
		if enemy_1_colliding_wall == 1:
			update_enemy_1_path_without_colliding()
		if enemy_1_colliding_wall == 2:
			enemy_1_raycast_down_path()
		if enemy_1_colliding_wall == 3:
			enemy_1_raycast_up_path()
		if enemy_1_colliding_wall == 4:
			enemy_1_raycast_right_path()
		if enemy_1_colliding_wall == 5:
			enemy_1_raycast_left_path()

func play_enemy_1_animation_pos_FOV():
	if player.position.y >= position.y:
		get_node("enemy_1_sprite").play("walking_front")
	if player.position.y <= position.y:
		if abs(player.position.y - position.y) < 40:
			if player.position.x > position.x:
				get_node("enemy_1_sprite").play("walking_right")
			if player.position.x < position.x:
				get_node("enemy_1_sprite").play("walking_left")
		else: get_node("enemy_1_sprite").play("walking_back")

func play_enemy_1_animation_pos():
	if enemy_1_velocity.x > 0:
		get_node("enemy_1_sprite").play("walking_right")
	if enemy_1_velocity.x < 0:
		get_node("enemy_1_sprite").play("walking_left")
	if enemy_1_velocity.y > 0:
		get_node("enemy_1_sprite").play("walking_front")
	if enemy_1_velocity.y < 0:
		get_node("enemy_1_sprite").play("walking_back")

func update_enemy_1_path_without_colliding():
	if random_direction_enemy_1 == 1:
		enemy_1_colliding_wall = 1
		enemy_1_velocity.y -= 0.06
		enemy_1_velocity.x = 0 
		move_and_slide(enemy_1_velocity * SPEED).normalized()

	if random_direction_enemy_1 == 2:
		enemy_1_colliding_wall = 1
		enemy_1_velocity.x += 0.06 
		enemy_1_velocity.y = 0
		move_and_slide(enemy_1_velocity * SPEED).normalized()

	if random_direction_enemy_1 == 3:
		enemy_1_colliding_wall = 1
		enemy_1_velocity.x -= 0.06 
		enemy_1_velocity.y = 0
		move_and_slide(enemy_1_velocity * SPEED).normalized()

	if random_direction_enemy_1 == 4:
		enemy_1_colliding_wall = 1
		enemy_1_velocity.y += 0.06 
		enemy_1_velocity.x = 0
		move_and_slide(enemy_1_velocity * SPEED).normalized()

func enemy_1_raycast_down_path():
	if timer_enemy_1_wall >= 60:
			enemy_1_velocity.x = 0
			enemy_1_velocity.y -= 0.06
			move_and_slide(enemy_1_velocity * SPEED).normalized()
	if timer_enemy_1_wall < 60:
		enemy_1_velocity.x = 0 
		enemy_1_velocity.y -= 0.06
		move_and_slide(enemy_1_velocity * SPEED).normalized()

func enemy_1_raycast_up_path():
	if timer_enemy_1_wall >= 60:
			enemy_1_velocity.x = 0
			enemy_1_velocity.y += 0.06
			move_and_slide(enemy_1_velocity * SPEED).normalized()
	if timer_enemy_1_wall < 60:
		enemy_1_velocity.x = 0 
		enemy_1_velocity.y += 0.06
		move_and_slide(enemy_1_velocity * SPEED).normalized()

func enemy_1_raycast_right_path():
	if timer_enemy_1_wall >= 60:
			enemy_1_velocity.x -= 0.06
			enemy_1_velocity.y = 0
			move_and_slide(enemy_1_velocity * SPEED).normalized()
	if timer_enemy_1_wall < 60:
		enemy_1_velocity.x -= 0.06 
		enemy_1_velocity.y = 0
		move_and_slide(enemy_1_velocity * SPEED).normalized()

func enemy_1_raycast_left_path():
	if timer_enemy_1_wall >= 60:
		enemy_1_velocity.x += 0.06 
		enemy_1_velocity.y = 0
		move_and_slide(enemy_1_velocity * SPEED).normalized()
	if timer_enemy_1_wall < 60:
		enemy_1_velocity.x += 0.06 
		enemy_1_velocity.y = 0
		move_and_slide(enemy_1_velocity * SPEED).normalized()
  
func _on_enemy_1_hit_area_entered(area):
	if area.is_in_group("bullet_1_hit_group"):
		ENEMY_1_LIFE -= 50
		get_node("monster_hit").play()
	else:
		null
	if ENEMY_1_LIFE == 0:
		destroy_enemy_1()

func destroy_enemy_1():
	queue_free()
