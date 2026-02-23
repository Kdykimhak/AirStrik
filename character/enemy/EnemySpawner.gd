extends Node2D

signal add_score

var spawn_positions = []
var Enemy = preload("res://character/enemy/Enemy.tscn")

@export var base_speed := 150.0        
@export var speed_step := 25.0         # Increase by 10 each step
@export var step_every_seconds := 5.0 # Increase speed every 15 seconds
@export var max_speed := 350.0         # Cap
@export var base_spawn_time := 1.5     # Starting spawn rate (seconds)
@export var min_spawn_time := 0.4      # Fastest spawn rate
@export var spawn_step := 0.1          # How much faster per step
@export var base_health := 1           # Starting health for the enemy

var start_time := 0

func _ready():
	randomize()
	spawn_positions = $SpawnPositions.get_children()
	start_time = Time.get_ticks_msec()

func spawn_enemy():
	var index = randi() % spawn_positions.size()
	var enemy = Enemy.instantiate()

	# ⏱ How long the game has been running
	var elapsed_seconds = (Time.get_ticks_msec() - start_time) / 1000.0

	# 🔼 Speed steps: 150 → 160 → 170 → ...
	var steps = int(elapsed_seconds / step_every_seconds)
	var final_speed = min(base_speed + steps * speed_step, max_speed)

	# Increase enemy health over time (like speed)
	var health_increase_steps = int(elapsed_seconds / 10)  # Increase health every 10 seconds
	var final_health = base_health + health_increase_steps  # Add the increased health to base_health

	enemy.speed = final_speed
	enemy.hp = final_health  # Set the health of the enemy based on time

	enemy.global_position = spawn_positions[index].global_position
	enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))
	add_child(enemy)

	print("Enemy speed:", final_speed, " | Health:", final_health, " | Spawn time:", $SpawnTimer.wait_time)

func _on_spawn_timer_timeout():
	_update_spawn_rate()
	spawn_enemy()

func _update_spawn_rate():
	var elapsed_seconds = (Time.get_ticks_msec() - start_time) / 1000.0
	var steps = int(elapsed_seconds / step_every_seconds)

	var new_wait_time = base_spawn_time - steps * spawn_step
	$SpawnTimer.wait_time = max(min_spawn_time, new_wait_time)

func _on_enemy_died():
	emit_signal("add_score")
