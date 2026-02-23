extends Node2D

var Laser = preload("res://projectiles/PlayerLaser.tscn")
var score = 0
var high_score = 0

@onready var background_music = $AudioStreamPlayer
@onready var score_label = $UI/Score
@onready var game_over = $UI/GameOver
@onready var restart_button = $UI/GameOver/Panel/Restart
@onready var high_score_label = $UI/GameOver/Panel/HighScore
@onready var start_screen_scene = preload("res://start_screen.tscn")

@onready var enemy_spawner = $EnemySpawner
@onready var player_node = $Player

var game_started = false

func _ready():
	load_high_score()
	background_music.play()

	# Spawn Start Screen
	var start_screen_instance = start_screen_scene.instantiate()
	$UI.add_child(start_screen_instance)
	start_screen_instance.connect("start_game", Callable(self, "_on_start_game"))

	# Connect signals
	enemy_spawner.connect("add_score", Callable(self, "_score"))
	player_node.connect("player_killed", Callable(self, "_on_player_killed"))
	restart_button.connect("pressed", Callable(self, "_on_restart_pressed"))

	game_over.visible = false

	# 🔒 Freeze everything at start
	_disable_gameplay()

func _disable_gameplay():
	game_started = false
	player_node.set_process(false)
	player_node.set_process_input(false)
	enemy_spawner.set_process(false)

func _enable_gameplay():
	game_started = true
	player_node.set_process(true)
	player_node.set_process_input(true)
	enemy_spawner.set_process(true)

# Player shooting
func _on_Player_spawn_laser(location):
	if not game_started:
		return
	var l = Laser.instantiate()
	l.global_position = location
	add_child(l)

func _score():
	if not game_started:
		return
	score += 10
	score_label.text = "SCORE: " + str(score)

func _on_player_killed():
	game_over.set_score(score)
	game_over.set_high_score(high_score)
	game_over.visible = true
	score_label.text = "Final Score: " + str(score)

	if score > high_score:
		high_score = score
		save_high_score()

func _on_restart_pressed():
	game_over.visible = false
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()

func _on_start_game():
	print("Starting Game!")

	var start_screen_node = $UI/StartScreen
	if start_screen_node:
		start_screen_node.queue_free()

	_enable_gameplay()

# Save / Load High Score
func save_high_score():
	var file = FileAccess.open("user://high_score.dat", FileAccess.WRITE)
	if file:
		file.store_var(high_score)
		file.close()

func load_high_score():
	if FileAccess.file_exists("user://high_score.dat"):
		var file = FileAccess.open("user://high_score.dat", FileAccess.READ)
		high_score = file.get_var()
		file.close()
