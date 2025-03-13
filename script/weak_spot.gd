extends Area3D

@export var damage :=1

signal was_hit(dam)

func hit():
	print("yo")
	emit_signal("was_hit", damage)
