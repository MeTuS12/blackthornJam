extends CenterContainer


var player = null

func _ready():
	player = get_tree().get_nodes_in_group('player')
	player = player[0]

func _on_QuitButton_pressed():
	visible = false
	player.fade_in()
	get_tree().paused = true
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().quit()



func _on_RetryButton_pressed():
	visible = false
	player.fade_in()
	get_tree().paused = true
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")


func _on_MainMenuButton_pressed():
	visible = false
	player.fade_in()
	get_tree().paused = true
	yield(get_tree().create_timer(.5), "timeout")
	Globals.fade_flag = true
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")
