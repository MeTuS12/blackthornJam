extends Node2D

export var difficulty = 0
export var name_dif = ""
export var easy = false
export var hard = false
export var very_hard = false

onready var label = $Label
onready var subtext_label = $SubLabel

var new_score = 0
var easy_score = 0
var hard_score = 0
var very_score = 0

func _ready():
	label.text = name_dif
	new_score = Globals.actual_score
	var save_data = SaveAndLoad.load_data_from_file()
	
	if easy:
#		easy_score = save_data.easy
		subtext_label.text = "MAX SCORE: " + str(save_data[0].easy)
	if hard:
#		hard_score = save_data.hard
		subtext_label.text = "MAX SCORE: " + str(save_data[0].hard)
	if very_hard:
#		very_score = save_data.very
		subtext_label.text = "MAX SCORE: " + str(save_data[0].very)
	
	
	if Globals.easy:
		if easy and Globals.score_flag:
			if new_score > save_data[0].easy:
				save_data[0].easy = new_score
				subtext_label.text = "MAX SCORE: " + str(new_score)
	if Globals.hard:
		if hard and Globals.score_flag:
			if new_score > save_data[0].hard:
				save_data[0].hard = new_score
				subtext_label.text = "MAX SCORE: " + str(new_score)
	if Globals.very_hard:
		if very_hard and save_data[0].very:
			if new_score > save_data[0].very:
				save_data[0].very = new_score
				subtext_label.text = "MAX SCORE: " + str(new_score)


func _on_Area2D_body_entered(body):
	if body is Player:
		Globals.pause_flag = true
		Globals.score_needed = difficulty
		Globals.min_score = difficulty
		Globals.easy = easy
		Globals.hard = hard
		Globals.very_hard = very_hard
		Globals.actual_score = 0
		Globals.fade_flag = false
		body.fade_in()
		get_tree().paused = true
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().paused = false
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Main.tscn")


func _on_Area2D_body_exited(_body):
	pass
