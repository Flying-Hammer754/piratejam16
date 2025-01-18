extends VehicleBody3D

@export var speed: float = 15
#@export var acceleration: float = 0.2
#@export var brake_speed: float = 0.2
@export var brake_force: float = 100

# the 0.4 value was taken from https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/3d/truck_town/vehicles/vehicle.gd
@export var steer_speed: float = 0.4

@onready var ragdoll_time: float = 0.0

const player_common = preload("res://player_common.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#set_center_of_mass(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# steering is in radians
	
	steering = Input.get_axis("player_move_right", "player_move_left") * steer_speed
	#if steering > Input.get_axis("player_move_right", "player_move_left") * PI - 0.2:
		#steering = Input.get_axis("player_move_right", "player_move_left") * PI
	#else: if steering < Input.get_axis("player_move_right", "player_move_left") * PI / 10:
		#steering = 0
	engine_force = Input.get_axis("player_move_forward", "player_move_backwards") * speed
	#if engine_force > Input.get_axis("player_move_forward", "player_move_backwards") * speed - speed / 8:
		#engine_force = Input.get_axis("player_move_forward", "player_move_backwards") * speed
	#else: if engine_force < speed / 10:
		#engine_force = 0
	if Input.is_action_pressed("player_jump"):
		brake = brake_force
		if linear_velocity.distance_squared_to(Vector3.ZERO) < 0.08:
			angular_velocity = Vector3.ZERO
		else:
			# For some reason, the car goes in the opposite direction in a drift without the following line of code
			angular_velocity.x = -angular_velocity.x
		#if brake > brake_force - brake_force / 8:
			#brake = brake_force
	else:
		brake = 0.0
		#if brake < brake_force / 10:
			#brake = 0
	
	if Input.is_action_pressed("player_fall_over"):
		angular_velocity.x += 1
	
	ragdoll_time = player_common.handle_ragdoll(delta, ragdoll_time, self)
