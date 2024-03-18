extends Area2D

#Starts to play the music
func _on_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		$splinters.play()
