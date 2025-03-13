extends Node3D

const SPEED = 40.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: RayCast3D = $RayCast3D
@onready var explosion: GPUParticles3D = $GPUParticles3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	position += transform.basis * Vector3(0,0, -SPEED) * delta
	
	if ray.is_colliding():
		mesh.visible = false
		explosion.emitting = true
		ray.enabled=false
		
		if ray.get_collider().is_in_group("Weak Spot"):
			ray.get_collider().hit()
		
		await get_tree().create_timer(1.0).timeout
		queue_free()
		


func _on_timer_timeout() -> void:
	queue_free()
