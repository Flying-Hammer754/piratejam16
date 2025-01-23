extends Node3D

@export var movement_bounds: Vector2 = Vector2(-1, 1)

@export var speed: float = 0.6
@export_range(0, 360, 0.1, "radians_as_degrees") var rotation_speed: float = PI / 2

# TODO: 
@export var damage: int = 5

@export var knockback_to_player: float = 25

@export var player: RigidBody3D

@export_range(0, 1) var start_position: float = 0.4
@export_range(0, 360, 0.1, "radians_as_degrees") var start_rotation: float = 0.0
@export_enum("Left:-1", "Right:1") var direction: int = 1
@export_enum("Left:1", "Right:-1") var rotation_direction: int = 1

@onready var moving_saw: AnimatableBody3D = $MovingSaw
@onready var saw_mesh: Node3D = $MovingSaw/RotationHandle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moving_saw.sync_to_physics = false
	moving_saw.position.x = lerp(movement_bounds.x, movement_bounds.y, start_position)
	saw_mesh.rotation.z = start_rotation

func _physics_process(delta: float) -> void:
	var collision = moving_saw.move_and_collide(Vector3(speed * direction * delta, 0.0, 0.0))
	if collision != null && collision.get_collider() == player:
		player.apply_impulse(collision.get_normal() * knockback_to_player)
	#saw_mesh.rotation.z += rotation_speed * rotation_direction * delta 
	#if saw_mesh.rotation.z >= 2 * PI:
		#saw_mesh.rotation.z = 0.0
	#else: if saw_mesh.rotation.z <= -2 * PI:
		#saw_mesh.rotation.z = 0.0

	if moving_saw.position.x >= movement_bounds.y:
		#moving_saw.position.x = movement_bounds.y
		direction = -1
	else: if moving_saw.position.x <= movement_bounds.x:
		#moving_saw.position.x = movement_bounds.x
		direction = 1
