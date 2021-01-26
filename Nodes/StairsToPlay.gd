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
	
	
	if easy:
		easy_score = Globals.easy_score
		subtext_label.text = "MAX SCORE: " + str(easy_score)
	if hard:
		hard_score = Globals.hard_score
		subtext_label.text = "MAX SCORE: " + str(hard_score)
	if very_hard:
		very_score = Globals.very_score
		subtext_label.text = "MAX SCORE: " + str(very_score)
	
	
	if Globals.easy:
		if easy:
			if new_score > easy_score:
				Globals.easy_score = new_score
				subtext_label.text = "MAX SCORE: " + str(new_score)
	if Globals.hard:
		if hard:
			if new_score > hard_score:
				Globals.hard_score = new_score
				subtext_label.text = "MAX SCORE: " + str(new_score)
	if Globals.very_hard:
		if very_hard:
			if new_score > very_score:
				Globals.very_score = new_score
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
