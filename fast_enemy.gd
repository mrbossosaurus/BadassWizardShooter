extends CharacterBody3D

# --- Enemy Stats ---
@export var movement_speed: float = 6.0 #faster than base
@export var gravity_strength: float = 12.0
@export var max_health: int = 1 #super fuckin weak
@export var money_value: int = 15 #but you be making big bucks
#ENEMY DAMAGE--------------------------
@export var damage: int = 15
@export var attack_cooldown: float = 0.8 #time between attacks

var can_attack: bool = true
var attack_timer: float = 0.0
#------------------------------------
# --- Variables ---
var current_health: int
var player: CharacterBody3D
#var money_scene = preload("res://money.tscn")  # We'll create this next

func _ready() -> void:
	add_to_group("enemies")
	current_health = max_health
	# Find the player in the scene
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	#ATTACK COOLDOWN
	if not can_attack:
		attack_timer -= delta
		if attack_timer <= 0:
			can_attack = true
	
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity_strength * delta
	
	# Chase the player if we found one
	if player:
		chase_player()
		check_attack_player()
	
	# Move the enemy
	move_and_slide()

func chase_player() -> void:
	# Calculate direction to player (only X and Z, ignore Y)
	var direction_to_player = (player.global_position - global_position)
	direction_to_player.y = 0  # Don't move up/down toward player
	direction_to_player = direction_to_player.normalized()
	
	# Set velocity toward player
	velocity.x = direction_to_player.x * movement_speed
	velocity.z = direction_to_player.z * movement_speed

func take_damage(damage_amount: int) -> void:
	current_health -= damage_amount
	print("Enemy hit! Health: ", current_health)
	
	if current_health <= 0:
		die()

func die() -> void:
	print("Fast Enemy Died!")
	#DROP THAT MOOLAH
	var money_scene = preload("res://money.tscn")
	var money = money_scene.instantiate()
	get_tree().current_scene.add_child(money)
	money.global_position = global_position + Vector3(0,0.5,0) #drops above enemy
	
	queue_free()  # Remove the enemy from the scene
	
func check_attack_player() -> void:
	if not can_attack:
		return
		
	#check if the bad fella is close enough to kill
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player <= 2.0: #Attack range
		#deal damage to the playa
		if player.has_method("take_damage"):
			player.take_damage(damage)
			print("Enemy attacked player for ", damage, " damage!")
		
		#start the attack cooldown
		can_attack = attack_cooldown
