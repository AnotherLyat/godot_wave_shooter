extends Node3D

const enemy_scenes = [preload("res://scene/grim.tscn")]
const passive_scenes = [preload("res://scene/deer.tscn")]

func _too_close(spawn_location: Vector3, player: Vector3, safe_range: float) -> bool:
	return spawn_location.distance_to(player) < safe_range

func _location_free(spawn_location: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	var shape_query = PhysicsShapeQueryParameters3D.new()
	
	var sphere_shape = SphereShape3D.new()  
	sphere_shape.radius = 5.0
	
	shape_query.set_shape(sphere_shape)  
	shape_query.transform = Transform3D(Basis(), spawn_location) 
	
	var result = space_state.intersect_shape(shape_query, 1)
	return result.is_empty()

func spawn_enemy(player: Vector3):
	const safe_range = 10
	var spawn_location: Vector3
	var max_attempts = 100
	var attempts = 0
	
	if enemy_scenes.is_empty():
		return
	
	var enemy_scene = enemy_scenes.pick_random()
	var new_enemy = enemy_scene.instantiate()
	var valid_location = false
	
	while not valid_location and attempts < max_attempts:
		spawn_location = Vector3(
			randi_range(0, 97),
			-8,  # Ensure proper y-level for enemies
			randi_range(0, 97)
		)
		
		if not _too_close(spawn_location, player, safe_range) and _location_free(spawn_location):
			valid_location = true
		attempts += 1
	
	if valid_location:
		spawn_location.y = -8  # Final y-position assignment
		new_enemy.position = spawn_location
		add_child(new_enemy)

func spawn_deer(player: Vector3):
	const safe_range = 20
	var spawn_location: Vector3
	var max_attempts = 100
	var attempts = 0
	
	if passive_scenes.is_empty():
		return
	
	var passive_scene = passive_scenes.pick_random()
	var new_passive = passive_scene.instantiate()
	var valid_location = false
	
	while not valid_location and attempts < max_attempts:
		spawn_location = Vector3(
			randi_range(0, 97),
			-8,  # Ground-level for deer
			randi_range(0, 97)
		)
		
		if not _too_close(spawn_location, player, safe_range) and _location_free(spawn_location):
			valid_location = true
		attempts += 1
	
	if valid_location:
		new_passive.position = spawn_location
		add_child(new_passive)
