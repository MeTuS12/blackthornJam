extends Node2D

export var difficulty = 3

onready var score_label = $Label2

var score = Globals.max_score_easy
var new_score = 0

func _ready():
	new_score = Globals.actual_score
	if new_score > score:
		score = new_score
		Globals.max_score_easy = score
		score_label.text = "Max score: " + str(score)


func _on_Area2D_body_entered(body):
	if body is Player:
		Globals.min_score = difficulty
		get_tree().change_scene("res://Main.tscn")
