extends CharacterBody3D

# --- Variables ---
# We use @export so we can change these values in the Godot editor.
#HEALTH!!!!!!!----------------------
@export var max_health: int = 100
@export var current_health: int = 100
@export var invincibility_time: float = 1.0

var is_invincible: bool = false
var invincibility_timer: float = 0.0
#-------------------------------------
# How fast the player moves on the ground.
@export var movement_speed: float = 5.0
@export var jump_strength: float = 8.0 #how strong them legs are
#money-----------------------------------------------------
@export var current_money: int = 0

#Slidding--------------------
var is_sliding: bool = false
@export var slide_speed_multiplier: float = 1.5
@export var slide_friction: float = 0.8
var slide_timer: float = 0.0
@export var max_slide_time: float = 2.0
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
var original_shape_height: float
var original_camera_y: float
var is_shape_lowered: bool = false
#end of sliding

@export var gravity_strength: float = 12.0 # The downward force of gravity.
@export var mouse_sensitivity: float = 0.003 #sensitivity
@export var vertical_look_limit : float = 90.0 #keep camera from do backflips
#gun stuff ---------------------------------
@export var bullet_speed: float = 20.0
@export var fire_rate: float = 1.0 #time in seconds between each shot
#jump control-------------------
var can_jump: bool = true
#---------------------
var can_shoot: bool = true
var shoot_timer: float = 0.0
#end of gun stuff --------------------------------------
#camera storage
@onready var camera: Camera3D = $Camera3D
#to track vertical rotation stuff so we can limt it
var camera_rotation_x: float = 0.0
# --- Code ---
func _ready() -> void:
	#capture mouse movement so it doesnt leave the game
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	# Store original camera position for sliding
	original_camera_y = camera.position.y
func _input(event: InputEvent) -> void:
	#print("Input event detected: ", event)
	#check for mice movement
	if event is InputEventMouseMotion:
		
		#rotate the player left and right :) ... duh
		rotate_y(-event.relative.x * mouse_sensitivity)
		#rotate camera up down but not to much
		camera_rotation_x -= event.relative.y * mouse_sensitivity
		camera_rotation_x = clamp(camera_rotation_x, deg_to_rad(-vertical_look_limit), deg_to_rad(vertical_look_limit))
		
		#the thingy that acutualy does the looking
		camera.rotation.x = camera_rotation_x
# This function runs every physics frame (many times per second).
# 'delta' is the time that has passed since the last physics frame.
func _physics_process(delta: float) -> void:
	#print("=== PHYSICS PROCESS START ===")
	
	var player_velocity: Vector3 = velocity
	#print("Initial velocity: ", player_velocity)
	#STRONG INVINCIBILITY -------------------------
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			is_invincible = false
	#NO MORE STRONG PAST HERE -------------------------
		# --- Gravity and Jumping ---
# --- Gravity and Jumping ---
	if not is_on_floor():
		# Apply gravity when not on ground
		player_velocity.y -= gravity_strength * delta
		# Player is in the air, mark as not able to jump
		can_jump = false  # Reset jump ability when falling
	else:
		# Player just landed, reset jump ability
		can_jump = true    
# Check for jump input when on ground
	if Input.is_action_just_pressed("jump") and can_jump:
		player_velocity.y = jump_strength
		can_jump = false  # Prevent jumping again until landing
		#sliding----------------
	if Input.is_action_just_pressed("slide") and is_on_floor() and not is_sliding:
		start_slide()
		
	#Handle the good ol slidin
	if is_sliding:
		player_velocity = handle_slide_physics(delta, player_velocity)
		
		
	#-------SHOOTING----------
	#fire rate timer
	if shoot_timer > 0:
		shoot_timer -= delta
		if shoot_timer <= 0:
			can_shoot = true
	#check for shooting input
	#print("Can shoot: ", can_shoot, " | Shoot timer: ", shoot_timer)
	if Input.is_action_just_pressed("shoot") and can_shoot:
		#print("SHOOTING!")
		shoot()
		can_shoot = false
		shoot_timer = fire_rate
	# --- Movement Input ---
	if not is_sliding:  # Skip normal movement when sliding
		var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		#print("Raw input direction: ", input_direction)
		
		var move_direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
		#print("3D move direction: ", move_direction)
		
		if move_direction != Vector3.ZERO:
			player_velocity.x = move_direction.x * movement_speed
			player_velocity.z = move_direction.z * movement_speed
			#print("Applied movement, X/Z velocity: ", player_velocity.x, ", ", player_velocity.z)
		else:
			player_velocity.x = move_toward(velocity.x, 0, movement_speed)
			player_velocity.z = move_toward(velocity.z, 0, movement_speed)
			#print("No input, slowing down")
	
	#print("Final velocity before move_and_slide: ", player_velocity)
	velocity = player_velocity
	move_and_slide()
	#print("Actual velocity after move_and_slide: ", velocity)
	#print("=== PHYSICS PROCESS END ===")
func shoot() -> void:
	#load the BULLET!
	var bullet_scene = preload("res://bullet.tscn")
	var bullet = bullet_scene.instantiate()
			
	#add the bullet to this wonderfull !NOT AS A CHILD OF PLAYER!
	get_tree().current_scene.add_child(bullet)
			
	#Possition this wonderfull bullet in front of the player
	bullet.global_position = global_position + camera.global_transform.basis.z * -3.0
			
	#Make the bullet go boom forward
	var shoot_direction = -camera.global_transform.basis.z
	bullet.linear_velocity = shoot_direction * bullet_speed
func add_money(amount: int) -> void:
	current_money += amount
	print("Total money: $", current_money)

func take_damage(damage: int) -> void:
	if is_invincible:
		return #cant take damage while invincible... duhhhh
	
	current_health -= damage
	current_health = max(current_health, 0) #DONT GO BELOW ZERO....
	
	#print("Plaer took", damage, "damage! Health:", current_health, "/", max_health)
	
	#start invincibility period
	is_invincible = true
	invincibility_timer = invincibility_time
	
	if current_health <= 0:
		die()

func die() -> void:
	#print("Player died!")
	#just for nowjust restart the game pretty much
	get_tree().reload_current_scene()
	
func heal(amount: int) -> void:
	current_health =+ amount
	current_health = min(current_health, max_health) #DO NOT EXCEED MAX
	#print("Player healed for", amount, "! Health: !", current_health, "/", max_health)

func start_slide() -> void:
	is_sliding = true
	slide_timer = 0.0
	lower_collision_shape()
	print("YOU SLIDIN")
	
func handle_slide_physics(delta: float, player_velocity: Vector3) -> Vector3:
	slide_timer += delta
	
	#get current input
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if input_direction.length() > 0:
		var move_direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
		player_velocity.x = move_direction.x * movement_speed * slide_speed_multiplier
		player_velocity.z = move_direction.z * movement_speed * slide_speed_multiplier
	else:
		#apply friction
		player_velocity.x *= slide_friction
		player_velocity.z *= slide_friction
	
	if not Input.is_action_pressed("slide") or slide_timer >= max_slide_time or input_direction.length() == 0:
		end_slide()
	
	return player_velocity

func end_slide() -> void:
	is_sliding = false
	slide_timer = 0.0
	restore_collision_shape()
	print("stoped sliding")

func lower_collision_shape() -> void:
	print("Attempting to lower collision shape...")
	if collision_shape:
		print("Collision shape found: ", collision_shape.name)
		if collision_shape.shape:
			print("Shape found: ", collision_shape.shape.get_class())
			if not is_shape_lowered:
				if collision_shape.shape is CapsuleShape3D:
					var capsule = collision_shape.shape as CapsuleShape3D
					original_shape_height = capsule.height
					print("Original height: ", original_shape_height)
					capsule.height = original_shape_height * 0.5  # Half height
					collision_shape.position.y = -original_shape_height * 0.25  # Lower the shape
					# Also scale the visual mesh for immediate feedback
					if mesh_instance:
						mesh_instance.scale.y = 0.5
						mesh_instance.position.y = -original_shape_height * 0.25
					# Lower the camera to match
					camera.position.y = original_camera_y - (original_shape_height * 0.25)
					print("New height: ", capsule.height, " Position: ", collision_shape.position.y, " Camera Y: ", camera.position.y)
					is_shape_lowered = true
				elif collision_shape.shape is BoxShape3D:
					var box = collision_shape.shape as BoxShape3D
					original_shape_height = box.size.y
					box.size.y = original_shape_height * 0.5
					collision_shape.position.y = -original_shape_height * 0.25
					is_shape_lowered = true
			else:
				print("Shape already lowered")
		else:
			print("No shape found on collision node")
	else:
		print("Collision shape node not found")

func restore_collision_shape() -> void:
	if collision_shape and collision_shape.shape and is_shape_lowered:
		if collision_shape.shape is CapsuleShape3D:
			var capsule = collision_shape.shape as CapsuleShape3D
			capsule.height = original_shape_height
			collision_shape.position.y = 0
			# Restore visual mesh
			if mesh_instance:
				mesh_instance.scale.y = 1.0
				mesh_instance.position.y = 0
			# Restore camera position
			camera.position.y = original_camera_y
		elif collision_shape.shape is BoxShape3D:
			var box = collision_shape.shape as BoxShape3D
			box.size.y = original_shape_height
			collision_shape.position.y = 0
		is_shape_lowered = false
		print("Collision shape restored")
