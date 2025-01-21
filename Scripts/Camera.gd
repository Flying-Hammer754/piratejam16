extends Camera3D

@onready var player = get_node("../Player") 
   # Adjust path if this isn't correct

@export var fixed_y_position: float = 10.0
@export var x_offset: float = 0.0
@export var z_offset: float = 10.0

func _ready() -> void:
	# Make this camera the current active camera (Godot 4+)
	current = true

	# Lock in the camera's orientation so it never changes.
	# Example: rotate 90 degrees around X so we look straight down the -Z axis
	# or 45 degrees for a slightly angled top-down.
	var angle_degrees = 45.0
	var new_basis = Basis()
	# Rotate around the X-axis by angle_degrees
	new_basis = new_basis.rotated(Vector3(1, 0, 0), deg_to_rad(-angle_degrees))
	global_transform.basis = new_basis

func _physics_process(delta: float) -> void:
	if not player:
		return

	# We'll just update the camera's position in X and Z to follow the player
	# and keep Y fixed.
	var player_pos = player.global_transform.origin
	var new_origin = global_transform.origin

	new_origin.x = player_pos.x + x_offset
	new_origin.z = player_pos.z + z_offset
	new_origin.y = fixed_y_position  # never change Y
	print(player_pos)

	global_transform.origin = new_origin
