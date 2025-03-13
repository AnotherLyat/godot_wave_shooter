extends Node3D

@onready var player : Node = get_tree().get_nodes_in_group("Player")[0]
@onready var spawner: Node3D = $Spawner
@onready var spawn_timer: Timer = $WaveTimer
var time
var wave_number = 1

func _ready() -> void:
	spawn_timer.wait_time = 10

func _physics_process(delta: float) -> void:
	time = get_node("player/head/Camera3D/UI/WaveTimer")
	time.text = str(int(spawn_timer.time_left))
	get_tree().call_group("enemies", "_update_target_location", player.global_transform.origin)

func spawn_wave():
	for i in range(5):
		spawner.spawn_enemy(player.global_transform.origin)
	if wave_number % 1 == 0:
		spawner.spawn_deer(player.global_transform.origin)
	wave_number +=1

func _on_wave_timer_timeout() -> void:
	spawn_wave()
