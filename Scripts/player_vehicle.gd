extends VehicleBody3D

@export var speed: float = 15
#@export var acceleration: float = 0.2
#@export var brake_speed: float = 0.2
@export var brake_force: float = 100

# the 0.4 value was taken from https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/3d/truck_town/vehicles/vehicle.gd
@export var steer_speed: float = 0.4

@export var level: Node3D

@export var camera: Camera3D
@export var cannon_aim_indicator: MeshInstance3D
@export var cannon_fire_rate: float = 1.5

@onready var cannon_ball_spawn_position: Node3D = $Weapons/cannon/CannonBallSpawnPosition
@onready var cannon_cooldown: float = 0
@onready var cannon_mesh: Node3D = $Weapons/cannon

@onready var hammer_mesh: Area3D = $Weapons/Hammer

const RAY_LENGTH: float = 1000

@onready var ragdoll_time: float = 0.0

@export_flags_3d_physics var ground_layer

const item_ui_element = preload("res://Scenes/ui_item_element.tscn")
const cannon_ball = preload("res://Scenes/cannon_ball.tscn")

@onready var item_in_range: Node

@export var hammer_swing_speed: float = 2
@onready var swinging_hammer: bool = false

# Timer to check if the player has actually landed
var landing_timer: float = 0.0
const landing_duration: float = 0.2  # Time required to be grounded before considering landed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level.emit_signal("item_update_ui", collectible_item.WeaponKind.CANNON, true)
	cannon_mesh.visible = true
	#set_center_of_mass(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(body: Area3D) -> void:
	if body.get_collision_layer_value(3) && body.name == "CollectibleItem":
		item_in_range = body
	elif body.get_collision_layer_value(2):
		print("a")
		var game_over_panel = $/root/Game/GameOverPanel
		game_over_panel.visible = true

func _on_area_exited(body: Area3D) -> void:
	if item_in_range == body:
		item_in_range = null

func _on_hammer_body_entered(body: Node3D) -> void:
	body.queue_free()

func _input(event: InputEvent) -> void:
	if item_in_range != null:
		var ci: collectible_item = collectible_item.make("Hammer", "",null,null,collectible_item.WeaponKind.HAMMER,"",null)
		if ci.weapon_kind == collectible_item.WeaponKind.HAMMER:
			hammer_mesh.visible = true
		if level.emit_signal("item_update_ui", ci.weapon_kind, true) != ERR_UNAVAILABLE:
			pass

func _physics_process(delta: float) -> void:
	# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	var result = space_state.intersect_ray(query)
	if result:
		cannon_aim_indicator.position = result.position
		#cannon_ball_spawn_position.look_at(
			#Vector3(
				#result.position.x,
				#cannon_ball_spawn_position.position.y,
				#result.position.z
			#)
		#)
		cannon_mesh.look_at(
			Vector3(
				result.position.x,
				cannon_mesh.position.y,
				result.position.z
			)
		)
		if Input.is_action_pressed("player_shoot_cannon") && cannon_cooldown < 0:
			cannon_cooldown = cannon_fire_rate
			var c = cannon_ball.instantiate()
			level.add_child(c)
			c.global_position = cannon_ball_spawn_position.global_position
			c.global_rotation.y = cannon_ball_spawn_position.global_rotation.y
			
		
	
	cannon_cooldown -= delta
	
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
	
	if Input.is_action_pressed("player_swing_hammer") && hammer_mesh.visible:
		swinging_hammer = true
		hammer_mesh.monitoring = true
	
	if swinging_hammer:
		hammer_mesh.rotation.x += clampf(hammer_swing_speed * delta, 0.0, PI/2)
		hammer_mesh.rotation.x = clampf(hammer_mesh.rotation.x, 0.0, PI/2)
	
	if hammer_mesh.rotation.x >= PI/2 - 0.08:
		swinging_hammer = false
	
	if not swinging_hammer:
		hammer_mesh.monitoring = false
		hammer_mesh.rotation.x -= clampf(hammer_swing_speed * delta, 0.0, PI/2)
		hammer_mesh.rotation.x = clampf(hammer_mesh.rotation.x, 0.0, PI/2)
	
	if not hammer_mesh.visible:
		hammer_mesh.monitoring = false
	
	ragdoll_time = handle_ragdoll(delta, ragdoll_time, self)
	
	if is_grounded():
		landing_timer += delta  # Increment the timer while grounded
	else:
		landing_timer = 0.0  # Reset the timer if not grounded


func is_grounded() -> bool:
	# Check if the vehicle is colliding with any body on the ground layer
	for body in get_colliding_bodies():
		if body.collision_layer & ground_layer:
			return true
	return false

func is_fully_landed() -> bool:
	# Check if the player has been grounded for the required duration
	return landing_timer >= landing_duration

const start_of_ragdoll: float = 0.08

func handle_ragdoll(delta: float, ragdoll_time: float, out: RigidBody3D) -> float:
	if Vector2(out.rotation.x, out.rotation.z).distance_squared_to(Vector2.ZERO) < start_of_ragdoll:
		return 0.0
	else:
		ragdoll_time += delta
		if ragdoll_time > 5:
			var game_over_panel: Panel = $/root/Game/GameOverPanel
			game_over_panel.visible = true
			return 0.0
		else:
			return ragdoll_time
