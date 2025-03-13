extends Node3D

@onready var gun_ani: AnimationPlayer = $AnimationPlayer
@onready var barrel: RayCast3D = $CSGBox3D/RayCast3D

var BULLET = preload("res://scene/bullet.tscn")
var instances

@export var gun_type: String = "normal" 
@export var reserve_ammo: int = 10
@export var current_ammo: int = 10
@export var mag_size: int = 10

@export var fire_rate: float = .1
@export var reload_time: float = 2
@export var shoot_timer_time: float
@export var reload_timer_time: float

@export var is_reloading: bool
@export var ready_to_shoot: bool = true

var gui
var ammo_text

func has_infinite_ammo():
	return gun_type == "normal"

func can_reload():
	return (has_infinite_ammo() or reserve_ammo > 0) and current_ammo < mag_size

func current_ammo_depleted():
	return current_ammo <= 0

func reserve_ammo_depleted():
	return reserve_ammo <= 0 and not has_infinite_ammo()

func no_more_ammo():
	return reserve_ammo_depleted() and current_ammo_depleted()

func _ready() -> void:
	if has_infinite_ammo():
		reserve_ammo = -1  # Display as infinite
	else:
		current_ammo = reserve_ammo

	shoot_timer_time = fire_rate
	reload_timer_time = reload_time
	
	gui = get_parent().get_node("UI")
	ammo_text = gui.get_node("AmmoCounter")

func _process(delta: float) -> void:
	if is_reloading:
		ammo_text.text = "RELOADING..."
		_reset_reload(delta)
		return
	else:
		ammo_text.text = str(current_ammo) + "/" + (str(mag_size) if has_infinite_ammo() else str(reserve_ammo))

	if current_ammo_depleted() and can_reload():
		_reload_weapon()

	if Input.is_action_just_pressed("shoot") and ready_to_shoot and not is_reloading:
		if not no_more_ammo():
			_shoot()

	if not ready_to_shoot:
		_reset_shoot(delta)

func _shoot():
	ready_to_shoot = false
	current_ammo -= 1
	gun_ani.play("shooting")
	instances = BULLET.instantiate()
	instances.position = barrel.global_position
	instances.transform.basis = barrel.global_transform.basis
	get_tree().current_scene.add_child(instances)
	
	#split shot
	#instances = BULLET.instantiate()
	#instances.position = barrel.global_position
	#instances.transform.basis = barrel.global_transform.basis.rotated(Vector3.UP, -.1)
	#get_tree().current_scene.add_child(instances)
	
	#instances.transform.basis = barrel.global_transform.basis.rotated(Vector3.UP, -.1)
	
	#if i want to shoot with the bullet a bit on the side, maybe shotgun?
	#instances.position = barrel.global_position+ Vector3(1, 0, 0)

func _reset_shoot(delta):
	shoot_timer_time -= delta
	if shoot_timer_time <= 0:
		ready_to_shoot = true
		shoot_timer_time = fire_rate

func _reset_reload(delta):
	reload_timer_time -= delta
	if reload_timer_time <= 0:
		var ammo_to_reload = min(mag_size, reserve_ammo) if not has_infinite_ammo() else mag_size
		current_ammo = ammo_to_reload
		if not has_infinite_ammo():
			reserve_ammo -= ammo_to_reload
		is_reloading = false
		reload_timer_time = reload_time

func _reload_weapon():
	is_reloading = true
