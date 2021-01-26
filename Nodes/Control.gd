extends CenterContainer


onready var label = $TextureRect/VBoxContainer/Label

func _ready():
	label.text = "YOU NEED " + str(Globals.score_needed) + " CROWNS TO COMPLETE YOUR QUEST"
# warning-ignore:return_value_discarded
	Globals.connect("needed_score", self, "on_needed_score")


func on_needed_score():
	get_tree().paused = true
	visible = true

func _on_Button_pressed():
	get_tree().paused = false
	visible = false