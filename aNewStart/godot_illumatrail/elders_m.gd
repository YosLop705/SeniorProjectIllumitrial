extends Area2D

@export var player_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if player_id == 11:
		$THEMES.play("mes1")
	else:
		$THEMES.play("new_animation_%s" % [player_id])

func _on_body_exited(body):
	if body.name == "Player" || body.name == "Player2":
		hide()

func _on_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		show()

