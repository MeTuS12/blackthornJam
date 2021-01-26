extends Node2D


func _ready():
	Globals.emit_signal("needed_score")
