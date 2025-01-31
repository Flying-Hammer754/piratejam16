class_name collectible_item
extends Node

enum WeaponKind {
	NONE,
	HAMMER,
	CANNON
}

const hammer_object: PackedScene = preload("res://Scenes/weapon_hammer.tscn")

@export var tooltip: String
@export var texture_override: Texture2D
@export var ui_override: PackedScene
@export var weapon_kind: WeaponKind
@export var input_action: StringName
@export var object_override: PackedScene

static func make(
	_name: String,
	_tooltip: String,
	_texture_override: Texture2D,
	_ui_override: PackedScene,
	_weapon_kind: WeaponKind,
	_input_action: StringName,
	_object_override: PackedScene
) -> collectible_item:
	var out: collectible_item = new()
	out.name = _name
	out.tooltip = _tooltip
	out.texture_override = _texture_override
	out.ui_override = _ui_override
	out.weapon_kind = _weapon_kind
	out.input_action = _input_action
	out.object_override = _object_override
	return out
