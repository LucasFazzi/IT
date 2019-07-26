extends KinematicBody2D

onready var player = get_parent().get_node("player")
onready var enemy_1_modified_FOV = false
onready var enemy_1_modified

var ENEMY_1_MODIFIED_LIFE = 100
var RAND_SPEED = 0
var enemy_velocity = Vector2()
var random_direction = 0
var SPEED = 5
var enemy_1_modified_colliding_wall = 1
var timer = 250
var timer_2 = 100

func _ready():
	global.enemy_1_modified = self
	get_node("enemy_1_modified_FOV").add_to_group("fov_enemies")
	get_node("enemy_1_modified_hit").add_to_group("enemy_1_modified_hit")
	randomize()
	RAND_SPEED = randi()%100+90
	enemy_1_modified = global.enemy_1_modified

func _on_enemy_1_modified_FOV_body_entered(body):
	if body == player:
		get_node("animation_walk").play("zig_zag")
		enemy_1_modified_FOV = true
	else:
		get_node("animation_walk").stop()

func _on_enemy_1_modified_FOV_body_exited(body):
	if body == player:
		enemy_1_modified_FOV = false
	else:
		null

func _process(delta):
	timer -= 1
	if timer == 0:
		enemy_1_modified_colliding_wall = 1
		randomize()
		random_direction = randi()%4+1
		timer = 200

func _physics_process(delta):

	if get_node("raycast_down").is_colliding():
		enemy_1_modified_colliding_wall = 2
	if not get_node("raycast_down").is_colliding():
		timer_2 -= 1

	elif get_node("raycast_up").is_colliding():
		enemy_1_modified_colliding_wall = 3
	if not get_node("raycast_up").is_colliding():
		timer_2 -= 1

	elif get_node("raycast_right").is_colliding():
		enemy_1_modified_colliding_wall = 4
	if not get_node("raycast_right").is_colliding():
		timer_2 -= 1

	elif get_node("raycast_left").is_colliding():
		enemy_1_modified_colliding_wall = 5
	if not get_node("raycast_left").is_colliding():
		timer_2 -= 1

	if timer_2 == 0:
		enemy_1_modified_colliding_wall = 1

	if enemy_1_modified_FOV == true:

		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_collide(vec_to_player * RAND_SPEED * delta)

	if enemy_1_modified_FOV == false:
		if enemy_1_modified_colliding_wall == 1:
			update_path_without_colliding()
		elif enemy_1_modified_colliding_wall == 2:
			raycast_down_path()
		elif enemy_1_modified_colliding_wall == 3:
			raycast_up_path()
		elif enemy_1_modified_colliding_wall == 4:
			raycast_right_path()
		elif enemy_1_modified_colliding_wall == 5:
			raycast_left_path()

func update_path_without_colliding():

	if random_direction == 1:
		enemy_1_modified_colliding_wall = 1
		enemy_velocity.y -= 0.06
		enemy_velocity.x = 0 
		move_and_slide(enemy_velocity * SPEED).normalized()

	if random_direction == 2:
		enemy_1_modified_colliding_wall = 1
		enemy_velocity.x += 0.06 
		enemy_velocity.y = 0
		move_and_slide(enemy_velocity * SPEED).normalized()

	if random_direction == 3:
		enemy_1_modified_colliding_wall = 1
		enemy_velocity.x -= 0.06 
		enemy_velocity.y = 0
		move_and_slide(enemy_velocity * SPEED).normalized()

	if random_direction == 4:
		enemy_1_modified_colliding_wall = 1
		enemy_velocity.y += 0.06 
		enemy_velocity.x = 0
		move_and_slide(enemy_velocity * SPEED).normalized()

func raycast_down_path():
		enemy_velocity.x = 0
		enemy_velocity.y -= 0.06
		move_and_slide(enemy_velocity * SPEED).normalized()

func raycast_up_path():
		enemy_velocity.x = 0
		enemy_velocity.y += 0.06
		move_and_slide(enemy_velocity * SPEED).normalized()

func raycast_right_path():
		enemy_velocity.x -= 0.06 
		enemy_velocity.y = 0
		move_and_slide(enemy_velocity * SPEED).normalized()

func raycast_left_path():
		enemy_velocity.x += 0.06 
		enemy_velocity.y = 0
		move_and_slide(enemy_velocity * SPEED).normalized()
   
func _on_enemy_1_modified_hit_area_entered(area):
	if area.is_in_group("bullet_1_hit_group"):
		ENEMY_1_MODIFIED_LIFE -= 50
	else:
		null
	if ENEMY_1_MODIFIED_LIFE == 0:
		destroy_enemy_1_modified()

func destroy_enemy_1_modified():
	queue_free()