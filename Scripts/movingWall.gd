extends RigidBody3D


@export var move_speed: float = 2.0
@export var move_range: float = 5.0

var direction: int = 1
var start_position: Vector3

func _ready():
	start_position = global_transform.origin

func _process(delta: float):
	var new_pos = global_transform.origin
	new_pos.x += direction * move_speed * delta
	if abs(new_pos.x - start_position.x) > move_range:
		direction *= -1
	global_transform.origin = new_pos
