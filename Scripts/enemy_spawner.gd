extends Node3D

const enemy = preload("res://Scenes/Enemy1.tscn")

@onready var wave: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var score_panel_text: Label = $/root/Game/ScorePanel/Label
	score_panel_text.text = str("Score: ", wave)
	var enemy_count = ceili((wave as float) / 2)
	var enemy_health = ceili((wave as float) / 2)
	if get_child_count() == 0:
		wave += 1
		for i in range(0, enemy_count):
			var e = enemy.instantiate()
			add_child(e)
			e.emit_signal("set_health", enemy_health)
