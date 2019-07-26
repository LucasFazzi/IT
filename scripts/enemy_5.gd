extends KinematicBody2D

const SPEED = 1.5

onready var player = get_parent().get_node("player") 
onready var enemy_5_FOV = false
onready var enemy_5_fire = false
onready var clock_shoot = 1
onready var enemy_5_notifier = false
onready var enemy_5

var ENEMY_5_LIFE = 150
var RAND_SPEED = 0
var enemy_5_velocity = Vector2()
var random_direction_enemy_5 = 0
var enemy_5_colliding_wall = 1
var timer_enemy_5 = 250
var timer_2_enemy_5 = 100
var timer_enemy_5_wall = 0
var player_pos_to_enemy_5 = 0

func _ready():
	global.enemy_5 = self
	enemy_5 = global.enemy_5
	get_node("fov_enemy_5").add_to_group("fov_enemies")
	get_node("fov_enemy_5").add_to_group("enemy_5_hit_2")
	get_node("enemy_5_hit").add_to_group("enemy_5_hit")
	get_node(".").add_to_group("enemies")
	randomize()
	RAND_SPEED = randi()%100+1

func _on_fov_enemy_5_body_entered(body):
	if body == player:
		enemy_5_FOV = true
		enemy_5_fire = true
	else:
		null

func _on_fov_enemy_5_body_exited(body):
	if body == player:
		enemy_5_FOV = false

func _on_enemy_5_notifier_screen_entered():
	enemy_5_notifier = true

func _process(delta):
	timer_enemy_5 -= 1
	if timer_enemy_5 == 0:
		enemy_5_colliding_wall = 1
		randomize()
		random_direction_enemy_5 = randi()%4+1
		timer_enemy_5 = 250

	if player.position.y >= 1:
		player_pos_to_enemy_5 = 0
	if player_pos_to_enemy_5 <= 1:
		player_pos_to_enemy_5 = 1

func _physics_process(delta):
	if get_node("enemy_5_raycast_down").is_colliding():
		timer_enemy_5_wall += 1
		enemy_5_colliding_wall = 2
	if not get_node("enemy_5_raycast_down").is_colliding():
		timer_2_enemy_5 -= 1

	if get_node("enemy_5_raycast_up").is_colliding():
		timer_enemy_5_wall += 1
		enemy_5_colliding_wall = 3
	if not get_node("enemy_5_raycast_up").is_colliding():
		timer_2_enemy_5 -= 1

	if get_node("enemy_5_raycast_right").is_colliding():
		timer_enemy_5_wall += 1
		enemy_5_colliding_wall = 4
	if not get_node("enemy_5_raycast_right").is_colliding():
		timer_2_enemy_5 -= 1

	if get_node("enemy_5_raycast_left").is_colliding():
		timer_enemy_5_wall += 1
		enemy_5_colliding_wall = 5
	if not get_node("enemy_5_raycast_left").is_colliding():
		timer_2_enemy_5 -= 1

	if timer_2_enemy_5 == 0:
		enemy_5_colliding_wall = 1

	if timer_enemy_5_wall >= 250:
		timer_enemy_5_wall = 0

	if enemy_5_FOV == true:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_collide(vec_to_player * RAND_SPEED * delta)
		play_enemy_5_animation_pos_FOV()

	if enemy_5_fire == true and enemy_5_notifier == true:
		clock_shoot -= 1
	else:
		null
	if clock_shoot == 0:
		clock_shoot += randi()%190+1
		enemy_5_shoot_up()
		enemy_5_shoot_down()
		enemy_5_shoot_right()
		enemy_5_shoot_left()
	if enemy_5_FOV == false:
		null

	if enemy_5_FOV == false:
		play_enemy_5_animation_pos()
		if enemy_5_colliding_wall == 1:
			update_enemy_5_path_without_colliding()
		if enemy_5_colliding_wall == 2:
			enemy_5_raycast_down_path()
		if enemy_5_colliding_wall == 3:
			enemy_5_raycast_up_path()
		if enemy_5_colliding_wall == 4:
			enemy_5_raycast_right_path()
		if enemy_5_colliding_wall == 5:
			enemy_5_raycast_left_path()

func 	play_enemy_5_animation_pos_FOV():
	if player.position.y >= position.y:
		get_node("enemy_5_sprite").play("walking_front")
	if player.position.y <= position.y:
			if abs(player.position.y - position.y) < 40:
				if player.position.x > position.x:
					get_node("enemy_5_sprite").play("walking_right")
				if player.position.x < position.x:
					get_node("enemy_5_sprite").play("walking_left")
			else: get_node("enemy_5_sprite").play("walking_back")

func play_enemy_5_animation_pos():
	if enemy_5_velocity.x > 0:
		get_node("enemy_5_sprite").play("walking_right")
	if enemy_5_velocity.x < 0:
		get_node("enemy_5_sprite").play("walking_left")
	if enemy_5_velocity.y > 0:
		get_node("enemy_5_sprite").play("walking_front")
	if enemy_5_velocity.y < 0:
		get_node("enemy_5_sprite").play("walking_back")

func update_enemy_5_path_without_colliding():
	if random_direction_enemy_5 == 1:
		enemy_5_colliding_wall = 1
		enemy_5_velocity.y -= 0.06
		enemy_5_velocity.x = 0 
		move_and_slide(enemy_5_velocity * SPEED).normalized()

	if random_direction_enemy_5 == 2:
		enemy_5_colliding_wall = 1
		enemy_5_velocity.x += 0.06 
		enemy_5_velocity.y = 0
		move_and_slide(enemy_5_velocity * SPEED).normalized()

	if random_direction_enemy_5 == 3:
		enemy_5_colliding_wall = 1
		enemy_5_velocity.x -= 0.06 
		enemy_5_velocity.y = 0
		move_and_slide(enemy_5_velocity * SPEED).normalized()

	if random_direction_enemy_5 == 4:
		enemy_5_colliding_wall = 1
		enemy_5_velocity.y += 0.06 
		enemy_5_velocity.x = 0
		move_and_slide(enemy_5_velocity * SPEED).normalized()

func enemy_5_raycast_down_path():
	if timer_enemy_5_wall >= 60:
			enemy_5_velocity.x = 0
			enemy_5_velocity.y -= 0.06
			move_and_slide(enemy_5_velocity * SPEED).normalized()
	if timer_enemy_5_wall < 60:
		enemy_5_velocity.x = 0 
		enemy_5_velocity.y -= 0.06
		move_and_slide(enemy_5_velocity * SPEED).normalized()

func enemy_5_raycast_up_path():
	if timer_enemy_5_wall >= 60:
			enemy_5_velocity.x = 0
			enemy_5_velocity.y += 0.06
			move_and_slide(enemy_5_velocity * SPEED).normalized()
	if timer_enemy_5_wall < 60:
		enemy_5_velocity.x = 0 
		enemy_5_velocity.y += 0.06
		move_and_slide(enemy_5_velocity * SPEED).normalized()

func enemy_5_raycast_right_path():
	if timer_enemy_5_wall >= 60:
			enemy_5_velocity.x -= 0.06
			enemy_5_velocity.y = 0
			move_and_slide(enemy_5_velocity * SPEED).normalized()
	if timer_enemy_5_wall < 60:
		enemy_5_velocity.x -= 0.06
		enemy_5_velocity.y = 0
		move_and_slide(enemy_5_velocity * SPEED).normalized()

func enemy_5_raycast_left_path():
	if timer_enemy_5_wall >= 60:
			enemy_5_velocity.x += 0.06
			enemy_5_velocity.y = 0
			move_and_slide(enemy_5_velocity * SPEED).normalized()
	if timer_enemy_5_wall < 60:
		enemy_5_velocity.x += 0.06 
		enemy_5_velocity.y = 0
		move_and_slide(enemy_5_velocity * SPEED).normalized()

func _on_enemy_5_hit_area_entered(area):
	if area.is_in_group("bullet_1_hit_group"):
		destroy_enemy_5()
	else:
		null

func destroy_enemy_5():
	queue_free()

func enemy_5_shoot_up():
	var fire_up = preload("res://scenes/enemy_5_fire_up.tscn").instance()
	get_node("positon_up").add_child(fire_up)
	fire_up.set_as_toplevel(true)
	fire_up.show()
	fire_up.shoot_at_mouse_5_up(get_node("positon_up").position)

func enemy_5_shoot_down():
	var fire_down = preload("res://scenes/enemy_5_fire_down.tscn").instance()
	get_node("position_down").add_child(fire_down)
	fire_down.set_as_toplevel(true)
	fire_down.show()
	fire_down.shoot_at_mouse_5_down(get_node("position_down").position)

func enemy_5_shoot_right():
	var fire_right = preload("res://scenes/enemy_5_fire_right.tscn").instance()
	get_node("position_right").add_child(fire_right)
	fire_right.set_as_toplevel(true)
	fire_right.show()
	fire_right.shoot_at_mouse_5_right(get_node("position_right").position)

func enemy_5_shoot_left():
	var fire_left = preload("res://scenes/enemy_5_fire_left.tscn").instance()
	get_node("position_left").add_child(fire_left)
	fire_left.set_as_toplevel(true)
	fire_left.show()
	fire_left.shoot_at_mouse_5_left(get_node("position_left").position)