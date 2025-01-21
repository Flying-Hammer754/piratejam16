extends CharacterBody3D

@export var speed: float = 10.0  # Movement speed
@export var grab_radius: float = 2.0  # Radius for detecting rigid bodies
@export var hold_offset: Vector3 = Vector3(0, 1.0, -1.0)  # Offset for holding the object
@export var grab_layer: int = 1 << 1  # Layer 2 for grabbable objects

# Variables for movement and grabbing
var direction: Vector3 = Vector3.ZERO
var grabbed_object: RigidBody3D = null  # The currently grabbed object

func _process(delta: float) -> void:
	# Debug player position
	

	# Reset movement direction
	direction = Vector3.ZERO

	# Handle input for movement
	if Input.is_action_pressed("moveForward"):
		direction.z -= 1
	if Input.is_action_pressed("moveBackward"):
		direction.z += 1
	if Input.is_action_pressed("moveLeft"):
		direction.x -= 1
	if Input.is_action_pressed("moveRight"):
		direction.x += 1

	# Normalize direction for consistent speed
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Handle lift input
	if Input.is_action_pressed("lift"):
		if not grabbed_object:
			detect_and_grab_object()
	else:
		if grabbed_object:
			release_object()

func _physics_process(delta: float) -> void:
	# Debug player position in physics process

	# Apply movement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Apply gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0

	# Move the character
	move_and_slide()

	# Keep the grabbed object at the hold position
	if grabbed_object:
		hold_object()

func detect_and_grab_object() -> void:
	# Detect objects within the grab radius
	var space_state = get_world_3d().direct_space_state
	var sphere_shape = SphereShape3D.new()
	sphere_shape.radius = grab_radius

	var query_params = PhysicsShapeQueryParameters3D.new()
	query_params.shape = sphere_shape
	query_params.transform = global_transform
	query_params.collision_mask = grab_layer  # Use layer 2

	var results = space_state.intersect_shape(query_params)

	# Grab the first detected RigidBody3D object
	for result in results:
		var collider = result.collider
		if collider is RigidBody3D:
			grabbed_object = collider
			grabbed_object.sleeping = true  # Disable physics-like behavior
			break  # Stop after grabbing the first object

func release_object() -> void:
	# Release the grabbed object
	if grabbed_object:
		grabbed_object.sleeping = false  # Re-enable physics
		grabbed_object = null

func hold_object() -> void:
	if grabbed_object:
		# Set the object's position relative to the player
		var hold_position = global_transform.origin + global_transform.basis * hold_offset
		var obj_transform = grabbed_object.global_transform
		obj_transform.origin = hold_position
		grabbed_object.global_transform = obj_transform
