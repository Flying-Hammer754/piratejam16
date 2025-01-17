extends RigidBody3D

@export var speed: float = 18.0
@export var airspeed: float = 10.0
@export var jump_strength: float = 150
@export var start_of_ragdoll: float = 0.08
@export var max_velocity: float = 36
@export var ground: Node3D

var ragdoll_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_center_of_mass(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_ragdoll() -> void:
	if Vector2(rotation.x, rotation.z).distance_squared_to(Vector2.ZERO) < start_of_ragdoll:
		ragdoll_time = 0.0
	else:
		ragdoll_time += get_process_delta_time()
		print("R", Vector2(rotation.x, rotation.z).distance_squared_to(Vector2.ZERO))
		if ragdoll_time > 4:
			axis_lock_linear_x = true
			axis_lock_linear_y = true
			axis_lock_linear_z = true
			rotation.x = 0.0 #rotation.move_toward(Vector3(0.0, 0.0, 0.0), delta * (rotation.distance_squared_to(Vector3(0.0, 0.0, 0.0)) + 1.0))
			rotation.z = 0.0
			position.y += 0.5
			angular_velocity = Vector3(0.0, 0.0, 0.0)
			print(rotation_degrees)
			axis_lock_linear_x = false
			axis_lock_linear_y = false
			axis_lock_linear_z = false
			ragdoll_time = 0

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector(
			"player_move_left", "player_move_right",
			"player_move_forward", "player_move_backwards"
			)
	var movement_direction: Vector3 = Vector3(input_direction.x, 0.0, input_direction.y).normalized()
	if get_colliding_bodies().has(ground):
		movement_direction *= speed
		# This was supposed to be for the player character to get up after being knocked down
		# but, no matter what i try it doesn't work, so i got rid of it and locked the rotation on the player.
		
		handle_ragdoll()
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
