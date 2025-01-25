extends Node3D

signal ui_refresh_items(items: Array[collectible_item])
signal player_add_item_to_inventory(item: collectible_item)

# TODO: set input action and object override to non null
@onready var player_items: Array[collectible_item] = [
	collectible_item.make(
		"Hammer",
		"Press [E] to use the hammer",
		null,
		null,
		collectible_item.WeaponKind.HAMMER,
		"player_swing_hammer",
		null
	)
]

func _on_player_add_item_to_inventory(item: collectible_item):
	player_items.append(item)
	var items: Array[collectible_item] = player_items.duplicate()
	items.make_read_only()
	ui_refresh_items.emit(items)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var items: Array[collectible_item] = player_items.duplicate()
	items.make_read_only()
	ui_refresh_items.emit(items)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
