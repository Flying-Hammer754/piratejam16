extends RigidBody3D

@export var speed: float = 15.0  # Speed at which the enemy moves toward the player
@onready var player = $"../../VehicleBody3D"  # Reference to the player vehicle

func _ready() -> void:
	if player:
		print("Player found:", player.name)
	else:
		print("Player not found! Check the path.")

func _physics_process(delta: float) -> void:
	if not player:
		return  # Exit if the player reference is null

	# Calculate the direction to the player
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	
	# Move the enemy toward the player
	apply_central_force(direction * speed)
