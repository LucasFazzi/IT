extends TextureProgress

var ammo_bar = 250
var ammo_bar_update = 1
var shield_update = 45

func _process(delta):
	value = ammo_bar

func _on_player_shoot_1():
	ammo_bar -= ammo_bar_update

func _on_player_shield_1():
	ammo_bar -= shield_update
