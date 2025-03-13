extends CharacterBody3D

var health = 1
const SPEED = 10.0
var State_list = ["MOVE", "IDLE"]
var state = "MOVE" 
var direction = Vector3.ZERO
var tempo = 0
var is_fleeing = false

@onready var navi_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: Node = get_tree().get_nodes_in_group("Player")[0]
@onready var raycast: RayCast3D = $RayCast3D
@onready var state_timer: Timer = $State_timer
@onready var despawner: Timer = $Despawner

func _ready() -> void:
	state_timer.start()

func _physics_process(delta: float) -> void:
	
	if _danger_zone():
		direction = (global_transform.origin - player.global_transform.origin).normalized()
	
	if raycast.is_colliding():
		direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	
	look_at(global_transform.origin + direction, Vector3.UP, true)
	velocity = direction * SPEED
	move_and_slide()

func _on_timer_timeout() -> void:
	state = State_list.pick_random()
	
	match state:
		"MOVE":
			direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
			tempo = randi_range(1,5)
		"IDLE":
			direction = Vector3.ZERO
			tempo = randi_range(1,2)
	state_timer.start(tempo)
	
func _danger_zone():
	var distance = global_transform.origin.distance_to(player.global_transform.origin)
	if distance < 10:
		state_timer.stop()
		is_fleeing = true
	if distance > 15 and is_fleeing:
		state_timer.start(0)
		is_fleeing = false
	return is_fleeing


func _on_despawner_timeout() -> void:
	queue_free()


func _on_area_3d_was_hit(dam: Variant) -> void:
	print("a")
