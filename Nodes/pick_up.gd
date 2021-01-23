extends Node2D


export var value = 2
export var weight = 1

var flag = false


func _ready():
	pass




func _on_Area2D_body_entered(body):
	if not flag and body is Player:
		flag = true
		body.call_deferred('pick', self)
