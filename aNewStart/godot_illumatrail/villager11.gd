extends Area2D




func _on_body_exited(body):
	if body.name == "Player":
		hide()
		 


func _on_body_entered(body):
	if body.name == "Player":
		show()
