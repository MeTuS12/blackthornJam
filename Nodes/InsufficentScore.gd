extends CenterContainer

onready var actual = $TextureRect/VBoxContainer/ActualScore
onready var required = $TextureRect/VBoxContainer/RequiredScore


func _ready():
	Globals.connect("score", self, "on_score")

func on_score():
	if Globals.actual_score < Globals.min_score:
		actual.text = "YOU HAVE: " + str(Globals.actual_score) + " CROWNS"
		required.text = "YOU NEED: " + str(Globals.min_score) + " CROWNS TO LEFT THE CASTLE"
	else:
		actual.text = "YOU HAVE: " + str(Globals.actual_score) + " CROWNS"
		required.text = "YOU COMPLETED THE QUEST AND ESCAPE THE CASTLE!!"

func _on_Button_pressed():
	get_tree().paused = false
	visible = false
