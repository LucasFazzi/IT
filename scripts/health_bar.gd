extends TextureProgress

var wakeometer = 28000
var health_update_enemy_1_hit = 7000
var health_update_enemy_1_modified_hit = 7000
var health_update_enemy_2_hit = 7000
var health_update_enemy_3_hit = 7000
var health_update_enemy_4_hit = 7000
var health_update_enemy_5_hit = 7000
var health_update_enemy_2_fire_hit = 14000
var health_update_enemy_5_fire_hit = 14000
var health_update_enemy_3_fire_hit = 280

func _process(delta):
	value = wakeometer
	wakeometer -= 1

func _on_player_enemy_1_hit():
	wakeometer -= health_update_enemy_1_hit
	value = wakeometer

func _on_player_enemy_1_modified_hit():
	wakeometer -= health_update_enemy_1_modified_hit
	value = wakeometer

func _on_player_enemy_2_hit():
	wakeometer -= health_update_enemy_2_hit
	value = wakeometer

func _on_player_enemy_2_fire_hit():
	wakeometer -= health_update_enemy_2_fire_hit
	value = wakeometer

func _on_player_enemy_3_fire_hit():
	wakeometer -= health_update_enemy_3_fire_hit
	value = wakeometer

func _on_player_enemy_3_hit():
	wakeometer -= health_update_enemy_3_hit
	value = wakeometer

func _on_player_enemy_4_hit():
	wakeometer -= health_update_enemy_4_hit
	value = wakeometer

func _on_player_enemy_5_fire_hit():
	wakeometer -= health_update_enemy_5_fire_hit
	value = wakeometer

func _on_player_enemy_5_hit():
	wakeometer -= health_update_enemy_5_hit
	value = wakeometer
