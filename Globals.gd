extends Node

# warning-ignore:unused_signal
signal score


var difficulty = 5
var min_score
var actual_score = 0

var max_score_easy = 0
var max_score_hard = 0

func _ready():
	min_score = difficulty
