extends Area2D
class_name Player

signal player_killed  # Signal to notify when the player is killed
signal spawn_laser(location)  # Signal to spawn laser

@onready var muzzle = $Muzzle  # Reference to the muzzle where the laser will spawn

var speed = 300
var input_vector = Vector2.ZERO
var hp = 3  # Starting health
var laser_scene = preload("res://projectiles/PlayerLaser.tscn")  # Preload the laser scene

var screen_size = Vector2.ZERO  # Variable to store screen size

func _ready():
	# Get the screen size dynamically when the scene is ready
	screen_size = get_viewport().size
	connect("spawn_laser", Callable(self, "_on_spawn_laser"))

# Called every frame to update player movement and actions
func _process(delta):
	# Handle player movement (WASD or arrow keys)
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	position += input_vector.normalized() * speed * delta

	# Ensure the player stays within screen bounds
	var padding = 10  # Optional padding to prevent the player from sticking to the edges
	position.x = clamp(position.x, padding, screen_size.x - padding)
	position.y = clamp(position.y, padding, screen_size.y - padding)

	# Shooting input: Check if the shoot button is pressed
	if Input.is_action_just_pressed("shoot"):
		shoot_laser()

# Take damage when colliding with enemies
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("player_killed")  # Emit the player_killed signal when health reaches 0
		queue_free()  # Remove the player from the scene

# Detect collision with enemies
func _on_area_entered(area: Area2D):
	if area.is_in_group("enemies"):
		area.take_damage(1)  # Deal damage to the enemy on collision
		take_damage(1)  # Deal damage to the player on collision

# Spawn a laser when the player presses the shoot button
func shoot_laser():
	emit_signal("spawn_laser", muzzle.global_position)  # Emit signal to spawn the laser

# This function is called when the spawn_laser signal is emitted
func _on_spawn_laser(location):
	var laser = laser_scene.instantiate()  # Instantiate the laser from the scene
	laser.position = location  # Set the laser's position to the muzzle's position
	get_parent().add_child(laser)  # Add the laser to the parent node
