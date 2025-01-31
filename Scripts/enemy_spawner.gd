extends Node3D

const enemy = preload("res://Scenes/Enemy1.tscn")

@onready var wave: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_child_count() == 0:
		wave += 1
		for i in range(0, wave):
			var e = enemy.instantiate()
			add_child(e)
