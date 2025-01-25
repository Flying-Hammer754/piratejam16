extends VehicleBody3D

@export var speed: float = 15
#@export var acceleration: float = 0.2
#@export var brake_speed: float = 0.2
@export var brake_force: float = 100

# the 0.4 value was taken from https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/3d/truck_town/vehicles/vehicle.gd
@export var steer_speed: float = 0.4

@export var level: Node3D

@export var max_health: int = 3

@onready var ragdoll_time: float = 0.0

const player_common = preload("res://Scripts/player_common.gd")
#const item_ui_element = preload("res://Scenes/ui_item_element.tscn")

@onready var item_in_range: Node

@export var hammer_damage: int = 1
@export var hammer_swing_speed: float = 10
@onready var hammer_object: Area3D = $Weapons/HammerObject
@onready var initial_hammer_object_position: Vector3 = hammer_object.position
var hammer_object_swinged_position: float = -1

@export var mounted_saw_damage: int = 1

var hammer_object_swing: bool = false

@onready var saw_object: Area3D = $Weapons/SawObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#set_center_of_mass(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(body: Area3D) -> void:
		if body.get_collision_layer_value(3):
			item_in_range = body

func _on_area_exited(body: Area3D) -> void:
	if item_in_range == body:
		item_in_range = null

func _on_hammer_object_body_entered(body: Node3D) -> void:
	if body.has_signal("take_damage"):
		body.emit_signal("take_damage", hammer_damage)

func _on_saw_object_body_entered(body: Node3D) -> void:
	if body.has_signal("take_damage"):
		body.emit_signal("take_damage", mounted_saw_damage)

func _input(event: InputEvent) -> void:
	for i in level.get("player_items"):
		if i.input_action != "" && event.is_action_pressed(i.input_action):
			if i.weapon_kind == collectible_item.WeaponKind.HAMMER:
				# TODO: move this into physics_process
				hammer_object_swing = true
				
	if event.is_action_pressed("player_pickup_item") && item_in_range != null:
		var item: collectible_item = collectible_item.make(
			"Saw",
			"Always active, inflicts damage on contact",
			null,
			null,
			collectible_item.WeaponKind.SAW,
			"",
			null
		)
		if level.emit_signal("player_add_item_to_inventory", item) == ERR_UNAVAILABLE:
			print("item pickup failed")

func _physics_process(delta: float) -> void:
	hammer_object.visible = false
	hammer_object.process_mode = Node.PROCESS_MODE_DISABLED
	saw_object.visible = false
	saw_object.process_mode = Node.PROCESS_MODE_DISABLED
	for i: collectible_item in level.get("player_items"):
		if i.weapon_kind == collectible_item.WeaponKind.HAMMER:
			hammer_object.visible = true
			hammer_object.process_mode = Node.PROCESS_MODE_INHERIT
		elif i.weapon_kind == collectible_item.WeaponKind.SAW:
			saw_object.visible = true
			saw_object.process_mode = Node.PROCESS_MODE_INHERIT
	
	# steering is in radians
	
	steering = Input.get_axis("player_move_right", "player_move_left") * steer_speed
	#if steering > Input.get_axis("player_move_right", "player_move_left") * PI - 0.2:
		#steering = Input.get_axis("player_move_right", "player_move_left") * PI
	#else: if steering < Input.get_axis("player_move_right", "player_move_left") * PI / 10:
		#steering = 0
	engine_force = Input.get_axis("player_move_forward", "player_move_backwards") * speed
	#if engine_force > Input.get_axis("player_move_forward", "player_move_backwards") * speed - speed / 8:
		#engine_force = Input.get_axis("player_move_forward", "player_move_backwards") * speed
	#else: if engine_force < speed / 10:
		#engine_force = 0
	if Input.is_action_pressed("player_jump"):
		brake = brake_force
		if linear_velocity.distance_squared_to(Vector3.ZERO) < 0.08:
			angular_velocity = Vector3.ZERO
		else:
			# For some reason, the car goes in the opposite direction in a drift without the following line of code
			angular_velocity.x = -angular_velocity.x
		#if brake > brake_force - brake_force / 8:
			#brake = brake_force
	else:
		brake = 0.0
		#if brake < brake_force / 10:
			#brake = 0
	
	if Input.is_action_pressed("player_fall_over"):
		angular_velocity.x += 1
	
	# TODO: remake the hammer weapon with area3d
	if hammer_object_swing && hammer_object.position.y > 0.08:
		hammer_object.position.y = clampf(hammer_object.position.y - hammer_swing_speed * delta, 0.0, initial_hammer_object_position.y)
		hammer_object.rotation.x = lerp_angle(-PI/2, 0.0, hammer_object.position.y / initial_hammer_object_position.y)
	elif hammer_object.position.y < initial_hammer_object_position.y - 0.08:
		hammer_object_swing = false
		hammer_object.position.y = clampf(hammer_object.position.y + hammer_swing_speed * delta, 0.0, initial_hammer_object_position.y)
		hammer_object.rotation.x = lerp_angle(-PI/2, 0.0, hammer_object.position.y / initial_hammer_object_position.y)

	#	TODO:
	
	ragdoll_time = player_common.handle_ragdoll(delta, ragdoll_time, self)
