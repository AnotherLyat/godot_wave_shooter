extends Control

@onready var hit_react: ColorRect = $HitReact

func _ready():
	pass
	
func _process(delta):
	pass


func _on_player_player_hit() -> void:
	hit_react.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_react.visible = false
