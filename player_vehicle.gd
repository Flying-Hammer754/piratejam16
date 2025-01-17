# TODO: figure out how to fix the cars handling

extends VehicleBody3D

@export var speed: float = 15
@export var acceleration: float = 0.2
@export var brake_speed: float = 0.2
@export var brake_force: float = 100
@export var steer_speed: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_center_of_mass(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# steering is in radians
	steering = Input.get_axis("player_move_right", "player_move_left") * PI
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
		brake = lerp(brake, brake_force, brake_speed)
		#if brake > brake_force - brake_force / 8:
			#brake = brake_force
	else:
		brake = 0.0
		#if brake < brake_force / 10:
			#brake = 0
	
