extends Control

const game_scene = preload("res://test_web_export.tscn")

@onready var new_game_button = $MainMenuPanel/VBoxContainer/NewGameButton
@onready var load_game_button = $MainMenuPanel/VBoxContainer/LoadGameButton
@onready var license_button = $MainMenuPanel/VBoxContainer/LicenseButton
@onready var quit_game_button = $MainMenuPanel/VBoxContainer/QuitGameButton
@onready var panel = $MainMenuPanel
@onready var license_panel = $MainMenuPanel/ScrollContainer/VBoxContainer

func _on_new_game_button_pressed() -> void:
	new_game_button.disabled = true
	load_game_button.disabled = true
	license_button.disabled = true
	quit_game_button.disabled = true
	panel.visible = false
	var game = game_scene.instantiate()
	add_child(game)

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
		
		#print(c["name"])
		#print(c["parts"][0]["copyright"])
		var third_party_copyright_info: Label = Label.new()
		third_party_copyright_info.autowrap_mode = TextServer.AUTOWRAP_WORD
		third_party_copyright_info.text = third_party_copyright_info.text + c["name"] + '\n'
		for authors in c["parts"][0]["copyright"]:
			third_party_copyright_info.text = third_party_copyright_info.text + authors + '\n'
		third_party_copyright_info.text = third_party_copyright_info.text + "License: " + c["parts"][0]["license"]
		license_panel.add_child(third_party_copyright_info)

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
