extends Node3D

const ramp_lifted_position: float = 0.0

@export var ramp_lift_speed: float = 1
@export var ramp_retract_speed: float = 2.2
@export var knockback_to_player: float = 16

@export var player: RigidBody3D

@onready var retractable_ramp: AnimatableBody3D = $AnimatableBody3D
@onready var ramp_collider: CollisionShape3D = $AnimatableBody3D/CollisionShape3D
@onready var area: Area3D = $Area3D
@onready var ramp_retracted_position = retractable_ramp.position.y

var ramp_cooldown: float = 0.2
var current_ramp_cooldown: float = 0

var player_in_area: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_area = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retractable_ramp.sync_to_physics = false

func _physics_process(delta: float) -> void:
	current_ramp_cooldown -= delta
	if player_in_area:
		ramp_collider.disabled = false
		if retractable_ramp.position.y < ramp_lifted_position && current_ramp_cooldown < 0:
			var collider = retractable_ramp.move_and_collide(Vector3(0, ramp_lift_speed * delta, 0))
			if collider != null && collider.get_collider() == player:
				player.apply_impulse(collider.get_normal() * knockback_to_player)
				current_ramp_cooldown = ramp_cooldown
	else:
		ramp_collider.disabled = true
		if retractable_ramp.position.y > ramp_retracted_position:
			retractable_ramp.position.y = lerp(retractable_ramp.position.y, ramp_retracted_position, ramp_retract_speed * delta)
