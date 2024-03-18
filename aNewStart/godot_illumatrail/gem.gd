extends Area2D

signal gem_collected

func _on_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		Global.gems_collected += 3
		gem_collected.emit()
		$CollectedSfx.play()
		hide()

func life():
	print("This isn't called!")

func _on_collected_sfx_finished():
	queue_free()
