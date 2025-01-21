extends Node3D

@export var close_speed: float = 2
@export var open_speed: float = 1
@export var cooldown_seconds: float = 5
@export var player: Node3D

@onready var left_wall: AnimatableBody3D = $LeftWall
@onready var left_wall_initial_position: float = left_wall.position.x
@onready var right_wall: AnimatableBody3D = $RightWall
@onready var right_wall_initial_position: float = right_wall.position.x

@onready var current_cooldown: float = cooldown_seconds
var opening: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	current_cooldown -= delta
	if opening:
		left_wall.position.x = lerp(left_wall.position.x, left_wall_initial_position, open_speed * delta)
		right_wall.position.x = lerp(right_wall.position.x, right_wall_initial_position, open_speed * delta)
		if left_wall.position.x < left_wall_initial_position + 0.05 && right_wall.position.x > right_wall_initial_position - 0.05:
			left_wall.position.x = left_wall_initial_position
			right_wall.position.x = right_wall_initial_position
			current_cooldown = cooldown_seconds
			opening = false
	elif current_cooldown < 0:
		var left_wall_collision = left_wall.move_and_collide(Vector3.RIGHT * close_speed * delta)
		var right_wall_collision = right_wall.move_and_collide(Vector3.LEFT * close_speed * delta)
		if left_wall_collision != null:
			if left_wall_collision.get_collider() == player && right_wall_collision != null && right_wall_collision.get_collider() == player:
				print("Game Over")
				player.position = Vector3.UP
			elif left_wall_collision.get_collider() == right_wall:
				opening = true
