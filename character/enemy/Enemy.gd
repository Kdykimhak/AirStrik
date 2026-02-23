extends Area2D

signal enemy_died

@export var speed := 150.0
var hp := 1

func _physics_process(delta):
	global_position.y += speed * delta

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("enemy_died")
		queue_free()
