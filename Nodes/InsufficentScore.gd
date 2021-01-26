extends CenterContainer

onready var actual = $TextureRect/VBoxContainer/ActualScore
onready var required = $TextureRect/VBoxContainer/RequiredScore
onready var continue_label = $TextureRect/VBoxContainer/Continue
onready var left_button = $TextureRect/VBoxContainer/HBoxContainer/VBoxContainer/Left

var player = null


func _ready():
# warning-ignore:return_value_discarded
	Globals.connect("score", self, "on_score")
	player = get_tree().get_nodes_in_group('player')
	player = player[0]

func on_score():
	if Globals.actual_score < Globals.min_score:
		left_button.visible = false
		continue_label.visible = false
		actual.text = "YOU HAVE: " + str(Globals.actual_score) + " CROWNS"
		required.text = "YOU NEED: " + str(Globals.min_score) + " CROWNS TO LEFT THE CASTLE"
	else:
		left_button.visible = true
		continue_label.visible = true
		actual.text = "YOU HAVE: " + str(Globals.actual_score) + " CROWNS"
		required.text = "YOU COMPLETED THE QUEST, NOW CAN LEFT THE CASTLE"

func _on_Button_pressed():
	get_tree().paused = false
	visible = false


func _on_Left_pressed():
	visible = false
	player.fade_in()
	get_tree().paused = true
	yield(get_tree().create_timer(.5), "timeout")
	Globals.fade_flag = true
	Globals.pause_flag = false
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")
