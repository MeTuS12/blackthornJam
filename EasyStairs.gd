extends "res://Nodes/StairsToPlay.gd"


func _ready():
	if Globals.easy:
		score = Globals.actual_score
		print(score)
		if new_score > score:
			new_score = score
			score_label.text = "Max score: " + str(new_score)
