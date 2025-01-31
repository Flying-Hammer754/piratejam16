extends RigidBody3D

@export var speed: float = 15.0  # Speed at which the enemy moves toward the player
@onready var player = $"../../VehicleBody3D"  # Reference to the player vehicle

# I made it so that health is the current wave / 2
# And enemy count is the current wave / 2
var health: int

signal take_damage(damage: int)
signal set_health(_max: int)

func _ready() -> void:
	set_health.connect(_on_set_health)
	take_damage.connect(_on_take_damage)
	if player:
		print("Player found:", player.name)
	else:
		print("Player not found! Check the path.")

func _physics_process(delta: float) -> void:
	if not player:
		return  # Exit if the player reference is null

	# Calculate the direction to the player
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	
	# Move the enemy toward the player
	apply_central_force(direction * speed)

func _on_set_health(_max: int) -> void:
	health = _max

func _on_take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		self.queue_free()
