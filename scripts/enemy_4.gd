extends KinematicBody2D

const SPEED = 2.5

onready var player = get_parent().get_node("player")
onready var player_ambush_1 = get_parent().get_node("player/player_catch1")
onready var player_ambush_2 = get_parent().get_node("player/player_catch2")
onready var enemy_4

var ENEMY_4_LIFE = 150
var RAND_SPEED = 0
var vec_to_player_ambush_1
var vec_to_player_ambush_2
var randi_ambush = 0
var enemy_4_FOV = 0
var enemy_4_get_position = false
var enemy_4_velocity = Vector2()
var random_direction_enemy_4 = 0
var enemy_4_colliding_wall = 1
var timer_enemy_4 = 250
var timer_2_enemy_4 = 100
var timer_enemy_4_wall = 0

func _ready():
	global.enemy_4 = self
	enemy_4 = global.enemy_4
	get_node("enemy_4_fov").add_to_group("fov_enemies")
	get_node("enemy_4_hit").add_to_group("enemy_4_hit")
	randomize()
	RAND_SPEED = randi()%180+100

func _on_enemy_4_fov_body_entered(body):
	if body == player:
		enemy_4_FOV = 1
		enemy_4_get_position = true
		randomize()
		randi_ambush = randi()%2+1
	else:
		null
func _on_enemy_4_fov_body_exited(body):
	if body == player:
		enemy_4_FOV = 0
		enemy_4_get_position = true
		randomize()
		randi_ambush = randi()%2+1
	else:
		null

func _process(delta):
	timer_enemy_4 -= 1
	if timer_enemy_4 == 0:
		enemy_4_colliding_wall = 1
		randomize()
		random_direction_enemy_4 = randi()%4+1
		timer_enemy_4 = 250

func _physics_process(delta):
	if get_node("enemy_4_raycast_down").is_colliding():
		timer_enemy_4_wall += 1
		enemy_4_colliding_wall = 2
	if not get_node("enemy_4_raycast_down").is_colliding():
		timer_2_enemy_4 -= 1

	if get_node("enemy_4_raycast_up").is_colliding():
		timer_enemy_4_wall += 1
		enemy_4_colliding_wall = 3
	if not get_node("enemy_4_raycast_up").is_colliding():
		timer_2_enemy_4 -= 1

	if get_node("enemy_4_raycast_right").is_colliding():
		timer_enemy_4_wall += 1
		enemy_4_colliding_wall = 4
	if not get_node("enemy_4_raycast_right").is_colliding():
		timer_2_enemy_4 -= 1

	if get_node("enemy_4_raycast_left").is_colliding():
		timer_enemy_4_wall += 1
		enemy_4_colliding_wall = 5
	if not get_node("enemy_4_raycast_left").is_colliding():
		timer_2_enemy_4 -= 1

	if timer_2_enemy_4 == 0:
		enemy_4_colliding_wall = 1

	if timer_enemy_4_wall >= 250:
		timer_enemy_4_wall = 0

	if enemy_4_FOV == 1:
		if randi_ambush == 1 and enemy_4_get_position == true:
			vec_to_player_ambush_1 = player_ambush_1.global_position - global_position
			vec_to_player_ambush_1 = vec_to_player_ambush_1.normalized()
			move_and_collide(vec_to_player_ambush_1 * RAND_SPEED * delta)
			play_enemy_4_animation_pos_FOV()
		if randi_ambush == 2 and enemy_4_get_position == true:
			vec_to_player_ambush_2 = player_ambush_2.global_position - global_position
			vec_to_player_ambush_2 = vec_to_player_ambush_2.normalized()
			move_and_collide(vec_to_player_ambush_2 * RAND_SPEED * delta)
			play_enemy_4_animation_pos_FOV()

	if enemy_4_FOV == 1:
		if randi_ambush == 1 and enemy_4_get_position == false:
			var vec_to_player = player.global_position - global_position
			vec_to_player = vec_to_player.normalized()
			move_and_collide(vec_to_player * RAND_SPEED * delta)
			play_enemy_4_animation_pos_FOV()
		if randi_ambush == 2 and enemy_4_get_position == false:
			var vec_to_player = player.global_position - global_position
			vec_to_player = vec_to_player.normalized()
			move_and_collide(vec_to_player * RAND_SPEED * delta)
			play_enemy_4_animation_pos_FOV()

	if enemy_4_FOV == 0:
		play_enemy_4_animation_pos()
		if enemy_4_colliding_wall == 1:
			update_enemy_4_path_without_colliding()
		if enemy_4_colliding_wall == 2:
			enemy_4_raycast_down_path()
		if enemy_4_colliding_wall == 3:
			enemy_4_raycast_up_path()
		if enemy_4_colliding_wall == 4:
			enemy_4_raycast_right_path()
		if enemy_4_colliding_wall == 5:
			enemy_4_raycast_left_path()

func _on_enemy_4_area_entered_player_position_area_entered(area):
	if area.is_in_group("player_catches"):
		enemy_4_get_position = false

func play_enemy_4_animation_pos_FOV():
	if player.position.y >= position.y:
		get_node("enemy_4_sprite").play("walking_front")
	if player.position.y <= position.y:
			if abs(player.position.y - position.y) < 40:
				if player.position.x > position.x:
					get_node("enemy_4_sprite").play("walking_right")
				if player.position.x < position.x:
					get_node("enemy_4_sprite").play("walking_left")
			else: get_node("enemy_4_sprite").play("walking_back")

func play_enemy_4_animation_pos():
	if enemy_4_velocity.x > 0:
		get_node("enemy_4_sprite").play("walking_right")
	if enemy_4_velocity.x < 0:
		get_node("enemy_4_sprite").play("walking_left")
	if enemy_4_velocity.y > 0:
		get_node("enemy_4_sprite").play("walking_front")
	if enemy_4_velocity.y < 0:
		get_node("enemy_4_sprite").play("walking_back")

func update_enemy_4_path_without_colliding():
	if random_direction_enemy_4 == 1:
		enemy_4_colliding_wall = 1
		enemy_4_velocity.y -= 0.06
		enemy_4_velocity.x = 0 
		move_and_slide(enemy_4_velocity * SPEED).normalized()

	if random_direction_enemy_4 == 2:
		enemy_4_colliding_wall = 1
		enemy_4_velocity.x += 0.06 
		enemy_4_velocity.y = 0
		move_and_slide(enemy_4_velocity * SPEED).normalized()

	if random_direction_enemy_4 == 3:
		enemy_4_colliding_wall = 1
		enemy_4_velocity.x -= 0.06 
		enemy_4_velocity.y = 0
		move_and_slide(enemy_4_velocity * SPEED).normalized()

	if random_direction_enemy_4 == 4:
		enemy_4_colliding_wall = 1
		enemy_4_velocity.y += 0.06 
		enemy_4_velocity.x = 0
		move_and_slide(enemy_4_velocity * SPEED).normalized()

func enemy_4_raycast_down_path():
	if timer_enemy_4_wall >= 60:
			enemy_4_velocity.x = 0
			enemy_4_velocity.y -= 0.06
			move_and_slide(enemy_4_velocity * SPEED).normalized()
	if timer_enemy_4_wall < 60:
		enemy_4_velocity.x = 0 
		enemy_4_velocity.y -= 0.06
		move_and_slide(enemy_4_velocity * SPEED).normalized()

func enemy_4_raycast_up_path():
	if timer_enemy_4_wall >= 60:
			enemy_4_velocity.x = 0
			enemy_4_velocity.y += 0.06
			move_and_slide(enemy_4_velocity * SPEED).normalized()
	if timer_enemy_4_wall < 60:
		enemy_4_velocity.x = 0 
		enemy_4_velocity.y += 0.06
		move_and_slide(enemy_4_velocity * SPEED).normalized()

func enemy_4_raycast_right_path():
	if timer_enemy_4_wall >= 60:
			enemy_4_velocity.x -= 0.06
			enemy_4_velocity.y = 0
			move_and_slide(enemy_4_velocity * SPEED).normalized()
	if timer_enemy_4_wall < 60:
		enemy_4_velocity.x -= 0.06
		enemy_4_velocity.y = 0
		move_and_slide(enemy_4_velocity * SPEED).normalized()

func enemy_4_raycast_left_path():
	if timer_enemy_4_wall >= 60:
			enemy_4_velocity.x += 0.06
			enemy_4_velocity.y = 0
			move_and_slide(enemy_4_velocity * SPEED).normalized()
	if timer_enemy_4_wall < 60:
		enemy_4_velocity.x += 0.06 
		enemy_4_velocity.y = 0
		move_and_slide(enemy_4_velocity * SPEED).normalized()

func _on_enemy_4_hit_area_entered(area):
	if area.is_in_group("bullet_1_hit_group"):
		ENEMY_4_LIFE -= 50
		check_enemy_4_life()

	if area.is_in_group("player_hit"):
		enemy_4_get_position = true
		randomize()
		randi_ambush = randi()%2+1
	else:
		null

func check_enemy_4_life():
	if ENEMY_4_LIFE == 0:
		destroy_enemy_4()
	else:
		null

func destroy_enemy_4():
	queue_free()
