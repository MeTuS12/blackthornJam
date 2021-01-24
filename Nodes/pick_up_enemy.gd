extends "res://Nodes/pick_up.gd"

class_name PickUpEnemy

onready var timer = $Timer

func _ready():
	flag = true
	timer.start()

func _on_Timer_timeout():
	flag = false

#func _on_Area2D_body_entered(body):
#	if body is Enemy:
#		queue_free()
#	._on_Area2D_body_entered(body)
