extends CenterContainer




func _on_QuitButton_pressed():
	get_tree().quit()



func _on_RetryButton_pressed():
	get_tree().change_scene("res://Main.tscn")
