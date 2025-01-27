extends Camera3D

@export var y_offset: float = 25.0  # Height above the player
@export var x_rotation: float = -80.0  # Fixed rotation on the x-axis
@onready var player = $"../VehicleBody3D"  # Reference to the player vehicle

var is_player_grounded: bool = true
var target_y_rotation: float = 0.0  # Target Y rotation for smooth interpolation
const rotation_smoothness: float = 0.1  # Smoothing factor for camera rotation

func _ready() -> void:
	# Set the fixed rotation of the camera
	var basis = Basis()
	basis = basis.rotated(Vector3(1, 0, 0), deg_to_rad(x_rotation))
	global_transform.basis = basis

func _physics_process(delta: float) -> void:
	if not player:
		return

	# Check if the player vehicle is fully landed
	is_player_grounded = player.is_fully_landed()

	# Get the player's position
	var player_position = player.global_transform.origin

	# Maintain the camera's position with an offset
	var target_position = Vector3(player_position.x, player_position.y + y_offset, player_position.z)
	global_transform.origin = target_position

	# Update the target Y rotation if the player is grounded
	if is_player_grounded:
		target_y_rotation = player.global_transform.basis.get_euler().y

	# Smoothly interpolate the camera's Y rotation toward the target
	var camera_rotation = global_transform.basis.get_euler()
	camera_rotation.y = lerp(camera_rotation.y, target_y_rotation, rotation_smoothness)
	global_transform.basis = Basis.from_euler(camera_rotation)
