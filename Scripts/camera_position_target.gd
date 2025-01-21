class_name  CameraPositionTarget extends Node3D

var target: Node3D
var offset: Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent_node_3d()
	offset = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = target.global_position + offset
