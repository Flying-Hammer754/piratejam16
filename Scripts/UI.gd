extends Control

const game_scene = preload("res://Scenes/test_web_export.tscn")
var instantiated_game_scene: Node

@export var autoload_game_world: bool = false

@onready var new_game_button = $MainMenuPanel/VBoxContainer/NewGameButton
@onready var load_game_button = $MainMenuPanel/VBoxContainer/LoadGameButton
@onready var license_button = $MainMenuPanel/VBoxContainer/LicenseButton
@onready var quit_game_button = $MainMenuPanel/VBoxContainer/QuitGameButton
@onready var main_menu_panel = $MainMenuPanel
@onready var license_panel = $MainMenuPanel/ScrollContainer/VBoxContainer

@onready var pause_menu_panel = $PauseMenuPanel
@onready var resume_button = $PauseMenuPanel/VBoxContainer/ResumeButton
@onready var restart_button = $PauseMenuPanel/VBoxContainer/RestartButton
@onready var settings_button = $PauseMenuPanel/VBoxContainer/SettingsButton
@onready var exit_to_menu_button = $PauseMenuPanel/VBoxContainer/ExitToMenuButton
@onready var exit_to_desktop_button = $PauseMenuPanel/VBoxContainer/ExitToDesktopButton

@onready var inventory_panel = $InventoryPanel
@onready var inventory_list = $InventoryPanel/HBoxContainer
@onready var hammer_item = $InventoryPanel/HBoxContainer/HammerItem
@onready var cannon_item = $InventoryPanel/HBoxContainer/CannonItem

@onready var game_over_panel = $GameOverPanel

@onready var score_panel = $ScorePanel

func toggle_score_panel(enabled: bool) -> void:
	score_panel.visible = enabled

func toggle_game_over(enabled: bool) -> void:
	game_over_panel.visible = enabled

func toggle_inventory(enabled: bool) -> void:
	inventory_panel.visible = enabled

func toggle_main_menu(enabled: bool) -> void:
	new_game_button.disabled = not enabled
	load_game_button.disabled = not enabled
	license_button.disabled = not enabled
	quit_game_button.disabled = not enabled
	main_menu_panel.visible = enabled
	
func toggle_pause_menu(enabled: bool):
	resume_button.disabled = not enabled
	restart_button.disabled = not enabled
	settings_button.disabled = not enabled
	exit_to_menu_button.disabled = not enabled
	exit_to_desktop_button.disabled = not enabled
	pause_menu_panel.visible = enabled

func _on_resume_button_pressed() -> void:
	toggle_main_menu(false)
	toggle_pause_menu(false)
	toggle_inventory(true)
	toggle_game_over(false)
	toggle_score_panel(true)
	get_tree().paused = false
	# TODO: add special logic to resume game

func _on_restart_button_pressed() -> void:
	remove_child(instantiated_game_scene)
	_on_new_game_button_pressed()

func _on_settings_button_pressed() -> void:
	pass # TODO:

func _on_exit_to_menu_button_pressed() -> void:
	toggle_pause_menu(false)
	toggle_main_menu(true)
	toggle_inventory(false)
	toggle_game_over(false)
	toggle_score_panel(false)
	instantiated_game_scene.disconnect("item_update_ui", _on_item_pickup)
	remove_child(instantiated_game_scene)
	get_tree().paused = false

func _on_exit_to_desktop_button_pressed() -> void:
	get_tree().quit()

func _on_new_game_button_pressed() -> void:
	toggle_pause_menu(false)
	toggle_main_menu(false)
	toggle_inventory(true)
	toggle_game_over(false)
	toggle_score_panel(true)
	get_tree().paused = false
	instantiated_game_scene = game_scene.instantiate()
	instantiated_game_scene.connect("item_update_ui", _on_item_pickup)
	add_child(instantiated_game_scene)

func _on_load_game_button_pressed() -> void:
	pass

func _on_license_button_pressed() -> void:
	if license_panel.get_child_count() > 0:
		for child in license_panel.get_children():
			license_panel.remove_child(child)
		return
		
	var godot_license: Label = Label.new()
	godot_license.text = Engine.get_license_text()
	license_panel.add_child(godot_license)
	
	for c in Engine.get_copyright_info():
		var third_party_copyright_info: Label = Label.new()
		third_party_copyright_info.autowrap_mode = TextServer.AUTOWRAP_WORD
		third_party_copyright_info.text = third_party_copyright_info.text + c["name"] + '\n'
		for authors in c["parts"][0]["copyright"]:
			third_party_copyright_info.text = third_party_copyright_info.text + authors + '\n'
		third_party_copyright_info.text = third_party_copyright_info.text + "License: " + c["parts"][0]["license"]
		license_panel.add_child(third_party_copyright_info)

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	toggle_main_menu(true)
	toggle_pause_menu(false)
	toggle_inventory(false)
	toggle_game_over(false)
	toggle_score_panel(false)
	if autoload_game_world:
		_on_new_game_button_pressed()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_pause_game"):
		toggle_pause_menu(true)
		toggle_inventory(false)
		get_tree().paused = true

func _on_item_pickup(item: collectible_item.WeaponKind, enabled: bool) -> void:
	if item == collectible_item.WeaponKind.HAMMER:
		hammer_item.visible = enabled
	elif item == collectible_item.WeaponKind.CANNON:
		cannon_item.visible = enabled
