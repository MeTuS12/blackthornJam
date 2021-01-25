extends Node

# warning-ignore:unused_signal
signal score


var difficulty = 5
var min_score
var actual_score = 0

func _ready():
	min_score = difficulty
