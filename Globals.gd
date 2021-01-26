extends Node

# warning-ignore:unused_signal
signal score
# warning-ignore:unused_signal
signal needed_score

var fade_flag = true
var pause_flag = false

var easy = false
var hard = false
var very_hard = false

var difficulty = 0
var min_score = 0
var actual_score = 0

var score_needed = 0

var easy_score = 0
var hard_score = 0
var very_score = 0

func _ready():
	min_score = difficulty
