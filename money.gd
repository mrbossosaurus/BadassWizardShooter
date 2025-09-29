extends Area3D

@export var money_value: int = 10
@export var pickup_distance: float = 1.5

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node3D) -> void:
	#check if you grabbed the money
	if body.is_in_group("player"):
		#give you money
		if body.has_method("add_money"):
			body.add_money(money_value)
			
		print("Picked up $", money_value)
		queue_free()
