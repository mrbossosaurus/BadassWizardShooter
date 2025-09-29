extends StaticBody3D

@export var box_cost: int = 75

var is_player_nearby: bool = false
var player: CharacterBody3D
var world_script: Node

# All possible upgrades
var upgrade_pool = [
	{"name": "Speed Boost", "type": "speed", "value": 1.5, "cost": 50},
	{"name": "Jump Power", "type": "jump", "value": 2.0, "cost": 60},
	{"name": "Health Boost", "type": "health", "value": 25, "cost": 75},
	{"name": "Fire Rate Up", "type": "fire_rate", "value": 0.03, "cost": 40},
	{"name": "Super Speed", "type": "speed", "value": 3.0, "cost": 100},
	{"name": "High Jump", "type": "jump", "value": 4.0, "cost": 120},
	{"name": "Tank Health", "type": "health", "value": 50, "cost": 150},
	{"name": "Rapid Fire", "type": "fire_rate", "value": 0.05, "cost": 80}
]

var current_choices: Array = []
var box_open: bool = false
var interact_pressed_last_frame: bool = false

@onready var interaction_area: Area3D = $InteractionArea

func _ready() -> void:
	# Connect the area signals
	interaction_area.body_entered.connect(_on_player_entered)
	interaction_area.body_exited.connect(_on_player_exited)

	# Find the world script to update UI
	world_script = get_tree().current_scene

	print("Mystery box initialized with cost: $", box_cost)

func _on_player_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_nearby = true
		player = body
		print("Player entered mystery box area - player money: $", player.current_money)
		update_interaction_prompt()

func _on_player_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_nearby = false
		player = null
		print("Player left mystery box area")
		update_interaction_prompt()

func _physics_process(_delta: float) -> void:
	# Handle interaction input in physics process instead of _input
	# This is more reliable because it runs every frame consistently
	var interact_pressed_this_frame = Input.is_action_pressed("interact")
	var interact_just_pressed = interact_pressed_this_frame and not interact_pressed_last_frame
	interact_pressed_last_frame = interact_pressed_this_frame

	# Check for interaction when box is closed
	if is_player_nearby and interact_just_pressed and not box_open:
		print("E pressed - attempting interaction!")
		interact_with_box()

	# Handle box choices and closing when open
	if box_open:
		if Input.is_action_just_pressed("ui_cancel"):
			print("Escape pressed - closing box")
			close_box()
			return
		
		# Check number keys for choices
		if Input.is_action_just_pressed("ui_accept"): # Space for choice 1 (temporary)
			print("Space presses - choosing first upgrade")
			choose_upgrade(0)
		# We can add more number key detection here if needed
		#add number key detection using Input.is_key_pressed for better relying on
		if Input.is_key_pressed(KEY_1):
			print("1 key presses - choosing first upgrade")
			choose_upgrade(0)
		elif Input.is_key_pressed(KEY_2):
			print("2 key pressed - choosing second upgrade")
			choose_upgrade(1)
		elif Input.is_key_pressed(KEY_3):
			print("2 key pressed - choosing second upgrade")
			choose_upgrade(2)

func update_interaction_prompt() -> void:
	if world_script and world_script.has_method("set_interaction_prompt"):
		if is_player_nearby and not box_open:
			var prompt = "Press E to use Mystery Box ($" + str(box_cost) + ")"
			if player and player.current_money < box_cost:
				prompt += " - NOT ENOUGH MONEY!"
			world_script.set_interaction_prompt(prompt)
			#make sure mystery box ui is hidden when just showing the interaction prompt
			if world_script.has_method("hide_mystery_box_choices"):
				world_script.hide_mystery_box_choices()
		elif box_open:
			world_script.set_interaction_prompt("")
		else:
			world_script.set_interaction_prompt("")
			if world_script.has_method("hide_mystery_box_choices"):
				world_script.hide_mystery_box_choices()

func interact_with_box() -> void:
	print("=== INTERACT WITH BOX CALLED ===")
	
	if not player:
		print("ERROR: No player reference!")
		return
		
	print("Player money: $", player.current_money, " | Box cost: $", box_cost)
	
	if player.current_money < box_cost:
		print("Not enough money! Player needs $", (box_cost - player.current_money), " more")
		return
	
	print("Player has enough money - opening box!")
	
	# Subtract the money first
	player.current_money -= box_cost
	print("Money subtracted! New balance: $", player.current_money)
	
	# Open the box and generate choices
	box_open = true
	generate_choices()
	
	#this will clear interaction text
	update_interaction_prompt()
	
	# Show choices in console and UI
	print("=== MYSTERY BOX OPENED ===")
	print("Available choices:")
	for i in range(current_choices.size()):
		print(str(i + 1), ". ", current_choices[i].name)
	print("Press 1, 2, 3, or SPACE for first choice | ESC to cancel")
	
	# Update UI if available
	if world_script and world_script.has_method("show_mystery_box_choices"):
		var choices_text = "=== MYSTERY BOX CHOICES===\n"
		for i in range(current_choices.size()):
			choices_text += str(i + 1) + ". " + current_choices[i].name + "\n"
		choices_text += "\nPress 1, 2, 3, to choose | ESC to cancel"
		world_script.show_mystery_box_choices(choices_text)

func generate_choices() -> void:
	current_choices = []
	var available_upgrades = upgrade_pool.duplicate()

	# Generate exactly 3 random choices
	for i in range(3):
		if available_upgrades.size() > 0:
			var random_index = randi() % available_upgrades.size()
			current_choices.append(available_upgrades[random_index])
			available_upgrades.remove_at(random_index)
	
	print("Generated ", current_choices.size(), " upgrade choices")

func choose_upgrade(choice_index: int) -> void:
	if choice_index >= current_choices.size():
		print("Invalid choice index: ", choice_index)
		return
	
	var chosen_upgrade = current_choices[choice_index]
	var upgrade_cost = chosen_upgrade.cost
	
	if player.current_money < upgrade_cost:
		print("Cannot afford ", chosen_upgrade.name, "! NEED $", upgrade_cost, " but only have $", player.current_money)
		return
	
	#deduct the cost of this specific upgrade
	player.current_money -= upgrade_cost
	print("Purchased ", chosen_upgrade.name, " for $", upgrade_cost, ". New balance: $", player.current_money)
	
	apply_upgrade(chosen_upgrade)
	close_box()

func apply_upgrade(upgrade: Dictionary) -> void:
	print("Applying upgrade: ", upgrade.name, " (", upgrade.type, " +", upgrade.value, ")")
	
	match upgrade.type:
		"speed":
			var old_speed = player.movement_speed
			player.movement_speed += upgrade.value
			print("Speed upgraded from ", old_speed, " to ", player.movement_speed)
		"jump":
			var old_jump = player.jump_strength
			player.jump_strength += upgrade.value
			print("Jump upgraded from ", old_jump, " to ", player.jump_strength)
		"health":
			var old_max_health = player.max_health
			player.max_health += upgrade.value
			player.current_health = player.max_health  # Full heal
			print("Max health upgraded from ", old_max_health, " to ", player.max_health)
		"fire_rate":
			var old_fire_rate = player.fire_rate
			player.fire_rate = max(0.02, player.fire_rate - upgrade.value)
			print("Fire rate upgraded from ", old_fire_rate, " to ", player.fire_rate)

func close_box() -> void:
	print("Closing mystery box")
	box_open = false
	current_choices = []
	update_interaction_prompt()

	# Hide UI
	if world_script and world_script.has_method("hide_mystery_box_choices"):
		world_script.hide_mystery_box_choices()
