extends CenterContainer

var player = null

onready var label = $TextureRect/VBoxContainer/Label

func _ready():
	label.text = "YOU NEED TO STEAL WORTH OF " + str(Globals.score_needed) + " TREASURES                    TO COMPLETE YOUR QUEST"
# warning-ignore:return_value_discarded
	Globals.connect("needed_score", self, "on_needed_score")


func on_needed_score():
	player = get_tree().get_nodes_in_group('player')
	player = player[0]
	player.fade_idle()
	get_tree().paused = true
	visible = true

func _on_Button_pressed():
	player.fade_out()
	get_tree().paused = false
	visible = false
