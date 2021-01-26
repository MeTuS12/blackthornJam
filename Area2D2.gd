extends Area2D



func _on_Area2D2_body_entered(body):
	if body is Player:
		get_tree().quit()
