extends CanvasLayer

# Notifies 'Main' Node that the button has been press
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# when player loses the game, show game over for 2s
# then return to title screen and, after a brief pause,
# show start button
func show_game_over():
	show_message("Game Over!")
	# wait until the MessageTimer has counted down
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	
	#Make a one shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
