extends Control

signal restart_game  # Define the signal

# Called when the restart button is pressed
func _on_restart_pressed():
	emit_signal("restart_game")  # Emit the signal to restart the game

# Set the final score
func set_score(score):
	$Panel/Score.text = "Score: " + str(score)  # Update the Score label

# Set the high score
func set_high_score(score):
	$Panel/HighScore.text = "High Score: " + str(score)  # Update the High Score label
