extends AudioStreamPlayer




func _on_boss_music_2_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		queue_free()
