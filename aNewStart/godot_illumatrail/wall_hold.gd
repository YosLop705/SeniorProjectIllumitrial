extends CharacterBody2D



func _on_runpass_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		queue_free()
