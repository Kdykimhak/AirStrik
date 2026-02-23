extends Control

signal start_game  # Define the signal to trigger the start game

@onready var start_button = $Panel/Start  # Reference to the Start Button

# Called when the start button is pressed
func _ready():
	start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))  # Connect the Start Button signal

# Function to handle the start button press
func _on_start_button_pressed():
	emit_signal("start_game")  # Trigger the start game signal
	hide()  # Hide the entire Start screen when the game starts
