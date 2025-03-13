extends CharacterBody3D

var health = 1
const SPEED = 5.0
var attack_range = 2.5

@onready var navi_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player : Node = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

func _ready() -> void:
	set_physics_process(false)

func _process(delta: float) -> void:
	match sprite.animation:
		"Moving":
			navi_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = navi_agent.get_next_path_position()
			var direction = (next_nav_point - global_transform.origin).normalized()
			
			velocity = direction * SPEED
			move_and_slide()
			
		"Attack":
			velocity = Vector3.ZERO
			if sprite.animation == "Attack" and  _hit_in_range():
				player._hit()

	if _target_in_range() and sprite.animation != "Attack":
		sprite.play("Attack")
	elif not _target_in_range() and sprite.animation != "Attack":
		sprite.play("Moving")

func _on_weak_spot_was_hit(dam: Variant) -> void:
	health -= dam
	if health <= 0: 
		queue_free()

func _target_in_range():
	
	return global_position.distance_to(player.global_transform.origin) < attack_range

func _hit_in_range():
	if sprite.frame == 4:
		return global_position.distance_to(player.global_transform.origin) < attack_range +1.0
	return false

func _on_animated_sprite_3d_animation_finished() -> void:
	if sprite.animation == "Attack":
		sprite.play("Moving")
