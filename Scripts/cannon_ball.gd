extends Area3D

const speed: float = 20
const damage: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if not body.has_signal("take_damage"):
		print("No take damage signal on enemy")
	
	body.emit_signal("take_damage", damage)

func _physics_process(delta: float) -> void:
	position.z -= speed * delta
	if position.length_squared() > 10000:
		print("exit")
		var p = $"../"
		p.queue_free()
