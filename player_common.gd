const start_of_ragdoll: float = 0.08

static func handle_ragdoll(delta: float, ragdoll_time: float, out: RigidBody3D) -> float:
	if Vector2(out.rotation.x, out.rotation.z).distance_squared_to(Vector2.ZERO) < start_of_ragdoll:
		return 0.0
	else:
		ragdoll_time += delta
		#print("R", Vector2(rotation.x, rotation.z).distance_squared_to(Vector2.ZERO))
		if ragdoll_time > 4:
			#axis_lock_linear_x = true
			#axis_lock_linear_y = true
			#axis_lock_linear_z = true
			out.rotation.x = 0.0 #rotation.move_toward(Vector3(0.0, 0.0, 0.0), delta * (rotation.distance_squared_to(Vector3(0.0, 0.0, 0.0)) + 1.0))
			out.rotation.z = 0.0
			out.position.y += 0.5
			out.angular_velocity = Vector3(0.0, 0.0, 0.0)
			#axis_lock_linear_x = false
			#axis_lock_linear_y = false
			#axis_lock_linear_z = false
			return 0.0
		else:
			return ragdoll_time
