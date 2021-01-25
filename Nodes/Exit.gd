extends Node2D


func _on_Area2D_body_entered(body):
	Globals.emit_signal("score")
	get_tree().paused = true
	body.insufficent_UI.visible = true
