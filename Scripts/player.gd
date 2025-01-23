extends RigidBody3D

@export var speed: float = 18.0
@export var airspeed: float = 10.0
@export var jump_strength: float = 150
@export var max_velocity: float = 36
@export var ground: Node3D

@onready var ragdoll_time: float = 0.0

const player_common = preload("res://player_common.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_center_of_mass(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector(
			"player_move_left", "player_move_right",
			"player_move_forward", "player_move_backwards"
			)
	var movement_direction: Vector3 = Vector3(input_direction.x, 0.0, input_direction.y).normalized()
	if get_colliding_bodies().has(ground):
		movement_direction *= speed

		ragdoll_time = player_common.handle_ragdoll(delta, ragdoll_time, self)
	else:
		movement_direction *= airspeed
	
	if Input.is_action_pressed("player_jump") and get_colliding_bodies().has(ground ):
		movement_direction.y += jump_strength
	
	if Input.is_action_pressed("player_fall_over"):
		angular_velocity.x = 8
	else: if linear_velocity.length_squared() < max_velocity:
		#linear_velocity.x = lerp(linear_velocity.x, movement_direction.x, 0.2)
		#linear_velocity.z = lerp(linear_velocity.z, movement_direction.z, 0.2)
		apply_impulse(movement_direction)
		#angular_velocity = Vector3.ZERO
		#rotation.y += movement_direction.x / speed * get_process_delta_time()
