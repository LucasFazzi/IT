extends KinematicBody2D

const SPEED = 5

onready var player = get_parent().get_node("player") 
onready var enemy_2_FOV = false
onready var enemy_2_fire = false
onready var clock_shoot = 1
onready var enemy_2_notifier = false
onready var enemy_2
onready var entered = false

var ENEMY_2_LIFE = 100
var RAND_SPEED = 0
var enemy_2_velocity = Vector2()
var random_direction_enemy_2 = 0
var enemy_2_colliding_wall = 1
var timer_enemy_2 = 250
var timer_2_enemy_2 = 100
var timer_enemy_2_wall = 0

func _ready():
	global.enemy_2 = self
	enemy_2 = global.enemy_2
	get_node("fov_enemy_2").add_to_group("fov_enemies")
	get_node("enemy_2_hit").add_to_group("enemy_2_hit")
	get_node(".").add_to_group("enemies")
	randomize()
	RAND_SPEED = randi()%60+15

func _on_entered_2_screen_entered():
	entered = true

func _on_fov_enemy_2_body_entered(body):
	if body == player:
		enemy_2_FOV = true
		enemy_2_fire = true
	else:
		null
func _on_fov_enemy_2_body_exited(body):
	if body == player:
		enemy_2_FOV = false

func _on_enemy_2_notifier_screen_entered():
	enemy_2_notifier = true

func _process(delta):
	timer_enemy_2 -= 1
	if timer_enemy_2 == 0:
		enemy_2_colliding_wall = 1
		randomize()
		random_direction_enemy_2 = randi()%4+1
		timer_enemy_2 = 250

func _physics_process(delta):
	if get_node("enemy_2_raycast_down").is_colliding():
		timer_enemy_2_wall += 1
		enemy_2_colliding_wall = 2
	if not get_node("enemy_2_raycast_down").is_colliding():
		timer_2_enemy_2 -= 1

	if get_node("enemy_2_raycast_up").is_colliding():
		timer_enemy_2_wall += 1
		enemy_2_colliding_wall = 3
	if not get_node("enemy_2_raycast_up").is_colliding():
		timer_2_enemy_2 -= 1

	if get_node("enemy_2_raycast_right").is_colliding():
		timer_enemy_2_wall += 1
		enemy_2_colliding_wall = 4
	if not get_node("enemy_2_raycast_right").is_colliding():
		timer_2_enemy_2 -= 1

	if get_node("enemy_2_raycast_left").is_colliding():
		timer_enemy_2_wall += 1
		enemy_2_colliding_wall = 5
	if not get_node("enemy_2_raycast_left").is_colliding():
		timer_2_enemy_2 -= 1

	if timer_2_enemy_2 == 0:
		enemy_2_colliding_wall = 1

	if timer_enemy_2_wall >= 250:
		timer_enemy_2_wall = 0

	if enemy_2_FOV == true and entered == true:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_collide(vec_to_player * RAND_SPEED * delta)
		play_enemy_2_animation_pos_FOV()

	if enemy_2_fire == true and enemy_2_notifier == true:
		clock_shoot -= 1
	else:
		null
	if clock_shoot == 0:
		clock_shoot += randi()%250+1
		enemy_2_shoot()
	if enemy_2_FOV == false:
		null

	if enemy_2_FOV == false and entered == true:
		play_enemy_2_animation_pos()
		if enemy_2_colliding_wall == 1:
			update_enemy_2_path_without_colliding()
		if enemy_2_colliding_wall == 2:
			enemy_2_raycast_down_path()
		if enemy_2_colliding_wall == 3:
			enemy_2_raycast_up_path()
		if enemy_2_colliding_wall == 4:
			enemy_2_raycast_right_path()
		if enemy_2_colliding_wall == 5:
			enemy_2_raycast_left_path()

func 	play_enemy_2_animation_pos_FOV():
	if player.position.y >= position.y:
		get_node("enemy_2_sprite").play("walking_front")
	if player.position.y <= position.y:
			if abs(player.position.y - position.y) < 40:
				if player.position.x > position.x:
					get_node("enemy_2_sprite").play("walking_right")
				if player.position.x < position.x:
					get_node("enemy_2_sprite").play("walking_left")
			else: get_node("enemy_2_sprite").play("walking_back")

func play_enemy_2_animation_pos():
	if enemy_2_velocity.x > 0:
		get_node("enemy_2_sprite").play("walking_right")
	if enemy_2_velocity.x < 0:
		get_node("enemy_2_sprite").play("walking_left")
	if enemy_2_velocity.y > 0:
		get_node("enemy_2_sprite").play("walking_front")
	if enemy_2_velocity.y < 0:
		get_node("enemy_2_sprite").play("walking_back")

func update_enemy_2_path_without_colliding():
	if random_direction_enemy_2 == 1:
		enemy_2_colliding_wall = 1
		enemy_2_velocity.y -= 0.06
		enemy_2_velocity.x = 0 
		move_and_slide(enemy_2_velocity * SPEED).normalized()

	if random_direction_enemy_2 == 2:
		enemy_2_colliding_wall = 1
		enemy_2_velocity.x += 0.06 
		enemy_2_velocity.y = 0
		move_and_slide(enemy_2_velocity * SPEED).normalized()

	if random_direction_enemy_2 == 3:
		enemy_2_colliding_wall = 1
		enemy_2_velocity.x -= 0.06 
		enemy_2_velocity.y = 0
		move_and_slide(enemy_2_velocity * SPEED).normalized()

	if random_direction_enemy_2 == 4:
		enemy_2_colliding_wall = 1
		enemy_2_velocity.y += 0.06 
		enemy_2_velocity.x = 0
		move_and_slide(enemy_2_velocity * SPEED).normalized()

func enemy_2_raycast_down_path():
	if timer_enemy_2_wall >= 60:
			enemy_2_velocity.x = 0
			enemy_2_velocity.y -= 0.06
			move_and_slide(enemy_2_velocity * SPEED).normalized()
	if timer_enemy_2_wall < 60:
		enemy_2_velocity.x = 0 
		enemy_2_velocity.y -= 0.06
		move_and_slide(enemy_2_velocity * SPEED).normalized()

func enemy_2_raycast_up_path():
	if timer_enemy_2_wall >= 60:
			enemy_2_velocity.x = 0
			enemy_2_velocity.y += 0.06
			move_and_slide(enemy_2_velocity * SPEED).normalized()
	if timer_enemy_2_wall < 60:
		enemy_2_velocity.x = 0 
		enemy_2_velocity.y += 0.06
		move_and_slide(enemy_2_velocity * SPEED).normalized()

func enemy_2_raycast_right_path():
	if timer_enemy_2_wall >= 60:
			enemy_2_velocity.x -= 0.06
			enemy_2_velocity.y = 0
			move_and_slide(enemy_2_velocity * SPEED).normalized()
	if timer_enemy_2_wall < 60:
		enemy_2_velocity.x -= 0.06
		enemy_2_velocity.y = 0
		move_and_slide(enemy_2_velocity * SPEED).normalized()

func enemy_2_raycast_left_path():
	if timer_enemy_2_wall >= 60:
			enemy_2_velocity.x += 0.06
			enemy_2_velocity.y = 0
			move_and_slide(enemy_2_velocity * SPEED).normalized()
	if timer_enemy_2_wall < 60:
		enemy_2_velocity.x += 0.06 
		enemy_2_velocity.y = 0
		move_and_slide(enemy_2_velocity * SPEED).normalized()

func _on_enemy_2_hit_area_entered(area):
	if area.is_in_group("bullet_1_hit_group"):
		ENEMY_2_LIFE -= 50
		get_node("monster_hit").play()
	else:
		null
	if ENEMY_2_LIFE <= 0:
		destroy_enemy_2()

func destroy_enemy_2():
	queue_free()

func enemy_2_shoot():
	var fire = preload("res://scenes/enemy_2_fire.tscn").instance()
	get_parent().add_child(fire)
	fire.show()
	fire.shoot_at_mouse_2(self.global_position)

