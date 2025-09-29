extends RigidBody3D

@export var damage: int = 1
@export var lifetime: float = 5.0

func _ready() -> void:
	# Remove bullet after lifetime
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)
	
	# Enable contact monitoring so we can detect collisions
	contact_monitor = true
	max_contacts_reported = 10

func _physics_process(_delta: float) -> void:
	# Check for collisions every frame
	var colliding_bodies = get_colliding_bodies()
	
	for body in colliding_bodies:
		print("Bullet hit: ", body.name)
		
		# Check if we hit an enemy
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()  # Remove bullet immediately after hit
			return
		
		# If we hit anything else (like ground), remove bullet
		if body is StaticBody3D:
			queue_free()
			return
