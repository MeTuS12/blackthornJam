extends CenterContainer



func _on_Resume_pressed():
	visible = false
	get_tree().paused = false


func _on_MainMenu_pressed():
	Globals.pause_flag = false
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Main.tscn")


func _on_Exit_pressed():
	get_tree().quit()
