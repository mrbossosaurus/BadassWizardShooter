extends Control

var player: CharacterBody3D
var is_shop_open: bool = false

# Upgrade costs
var speed_cost: int = 50
var jump_cost: int = 75
var health_cost: int = 100
var fire_rate_cost: int = 60

func _ready() -> void:
	# Set pause mode so this UI works when game is paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	# Connect buttons manually (safer than @onready)
	var close_btn = $ColorRect/VBoxContainer/CloseButton
	close_btn.pressed.connect(close_shop)
	
	var speed_btn = $ColorRect/VBoxContainer/SpeedButton
	speed_btn.pressed.connect(_on_speed_upgrade)
	
	var jump_btn = $ColorRect/VBoxContainer/JumpButton
	jump_btn.pressed.connect(_on_jump_upgrade)
	
	var health_btn = $ColorRect/VBoxContainer/HealthButton
	health_btn.pressed.connect(_on_health_upgrade)
	
	var fire_rate_btn = $ColorRect/VBoxContainer/FireRateButton
	fire_rate_btn.pressed.connect(_on_fire_rate_upgrade)
	
	hide()

func _unhandled_input(event: InputEvent) -> void:
	# Handle escape key and tab key
	if is_shop_open:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("open_shop"):
			close_shop()

func open_shop(player_ref: CharacterBody3D) -> void:
	print("Opening shop")
	player = player_ref
	is_shop_open = true
	update_display()
	show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close_shop() -> void:
	print("Closing shop")
	is_shop_open = false
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func update_display() -> void:
	if not player:
		return
		
	var money_label = $ColorRect/VBoxContainer/MoneyLabel
	money_label.text = "Money: $" + str(player.current_money)
	
	var speed_btn = $ColorRect/VBoxContainer/SpeedButton
	var jump_btn = $ColorRect/VBoxContainer/JumpButton
	var health_btn = $ColorRect/VBoxContainer/HealthButton
	var fire_rate_btn = $ColorRect/VBoxContainer/FireRateButton
	
	speed_btn.text = "Speed Boost - $" + str(speed_cost)
	speed_btn.disabled = player.current_money < speed_cost
	
	jump_btn.text = "Jump Boost - $" + str(jump_cost)
	jump_btn.disabled = player.current_money < jump_cost
	
	health_btn.text = "Health Boost - $" + str(health_cost)
	health_btn.disabled = player.current_money < health_cost
	
	fire_rate_btn.text = "Fire Rate Boost - $" + str(fire_rate_cost)
	fire_rate_btn.disabled = player.current_money < fire_rate_cost

func _on_speed_upgrade() -> void:
	if player.current_money >= speed_cost:
		player.current_money -= speed_cost
		player.movement_speed += 1.0
		speed_cost += 25
		update_display()
		print("Speed upgraded!")

func _on_jump_upgrade() -> void:
	if player.current_money >= jump_cost:
		player.current_money -= jump_cost
		player.jump_strength += 1.0
		jump_cost += 25
		update_display()
		print("Jump upgraded!")

func _on_health_upgrade() -> void:
	if player.current_money >= health_cost:
		player.current_money -= health_cost
		player.max_health += 25
		player.current_health = player.max_health
		health_cost += 50
		update_display()
		print("Health upgraded!")

func _on_fire_rate_upgrade() -> void:
	if player.current_money >= fire_rate_cost:
		player.current_money -= fire_rate_cost
		player.fire_rate = max(0.05, player.fire_rate - 0.02)
		fire_rate_cost += 30
		update_display()
		print("Fire rate upgraded!")
