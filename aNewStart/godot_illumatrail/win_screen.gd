extends Area2D


# Called when the node enters the scene tree for the first time.

var playersLeft = 2

func _on_body_exited(body):
	if body.name == "king":
		playersLeft = playersLeft - 1
		print("Player 1 died. Player count: ")
		print(playersLeft)

	if body.name == "queen":
		playersLeft = playersLeft - 1
		print("Player 2 died. Player count: ")
		print(playersLeft)
	
	
	if playersLeft == 0:
		print("VICTORY!")
		$openedTG.play()
		show()