extends Area2D




func _on_body_exited(body):
	if body.name == "Player" || body.name == "Player2":
		hide()
		 


func _on_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		show()
