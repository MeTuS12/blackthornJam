extends CenterContainer




func _on_QuitButton_pressed():
	get_tree().quit()



func _on_RetryButton_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")


func _on_MainMenuButton_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")
