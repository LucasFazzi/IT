extends Node

onready var player
onready var enemy_1
onready var enemy_2
onready var enemy_3
onready var enemy_4
onready var enemy_5

onready var bullet_1

onready var player_health 
onready var player_ammo 

func _ready():
	player = self
	enemy_1 = self
	enemy_2 = self
	enemy_3 = self
	enemy_4 = self
	enemy_5 = self
	bullet_1 = self

	player_health = self
	player_ammo = self