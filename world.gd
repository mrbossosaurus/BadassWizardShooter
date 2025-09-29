extends Node3D

@onready var money_label: Label = $CanvasLayer/Label
@onready var health_label: Label = $CanvasLayer/HealthLabel
@onready var interaction_label: Label = $CanvasLayer/InteractionLabel
@onready var mystery_box_ui: Label = $CanvasLayer/MysteryBoxUI
@onready var player: CharacterBody3D = $Player

@export var enemy_spawn_time: float = 5.0 #spawn every 5 seconds
@export var max_enemies: int = 8 #the amount of max enimies you can have at once
var spawn_timer: float = 0.0


#enemy scenes to spawn
var enemy_scenes = [
	preload("res://enemy.tscn"),
	preload("res://fast_enemy.tscn"),
	preload("res://tank_enemy.tscn")
]

var spawn_points = [
	Vector3(10, 2, 10),
	Vector3(-10, 2, 10),
	Vector3(10, 2, -10),
	Vector3(0, 2, 15),
	Vector3(0, 2, -15)
]

func _ready() -> void:
	spawn_timer = enemy_spawn_time

func _process(delta: float) -> void:
	# Update money and health as normal
	if player and money_label:
		money_label.text = "Money: $" + str(player.current_money)
	
	if player and health_label:
		health_label.text = "Health: " + str(player.current_health) + "/" + str(player.max_health)
	
	#handle enimie spawinging
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = enemy_spawn_time

func spawn_enemy() -> void:
	#count current enemies
	var current_enemies = get_tree().get_nodes_in_group("enemies")
	if current_enemies.size() >= max_enemies:
		return #Too many enemies
	
	#pick random enemy type for spawning
	var random_enemy = enemy_scenes[randi() % enemy_scenes.size()]
	var random_spawn = spawn_points[randi() % spawn_points.size()]
	
	#Create and add the enemy to the fight
	var enemy = random_enemy.instantiate()
	add_child(enemy)
	enemy.global_position = random_spawn
	
	
	print("Spawned enemy at: ", random_spawn)
	
	
func set_interaction_prompt(text: String) -> void:
	if interaction_label:
		interaction_label.text = text

func show_mystery_box_choices(choices_text: String) -> void:
	if mystery_box_ui:
		mystery_box_ui.text = choices_text
		mystery_box_ui.show()
		
func hide_mystery_box_choices() -> void:
	if mystery_box_ui:
		mystery_box_ui.text = ""
		mystery_box_ui.hide()
