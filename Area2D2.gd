extends Area2D



func _on_Area2D2_body_entered(body):
	if body is Player:
		body.fade_in()
		get_tree().paused = true
		yield(get_tree().create_timer(.5), "timeout")
		get_tree().quit()
