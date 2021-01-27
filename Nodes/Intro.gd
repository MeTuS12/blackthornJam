extends Node2D

var paper0 = load("res://Assets/intro/paper0.png")
var paper1 = load("res://Assets/intro/paper1.png")
var paper2 = load("res://Assets/intro/paper2.png")
var paper3 = load("res://Assets/intro/paper3.png")

var papers = [paper0, paper1, paper2, paper3]
var next_page = 0
var flag = true

onready var space_label = $CanvasLayer/CenterContainer/TextureRect/Label
onready var texture = $CanvasLayer/CenterContainer/TextureRect
onready var audio = $AudioStreamPlayer

func _physics_process(_delta):
	VisualServer.set_default_clear_color(Color.black)
	if Input.is_action_just_pressed("ui_accept") and flag:
		space_label.visible = false
		intro()
	

func intro():
	if next_page < papers.size() - 1:
		flag = false
		audio.play()
		yield(get_tree().create_timer(.3), "timeout")
		next_page += 1
	else:
# warning-ignore:return_value_discarded
		yield(get_tree().create_timer(.1), "timeout")
		get_tree().change_scene("res://MainMenu.tscn")
	yield(get_tree().create_timer(.3), "timeout")
	space_label.visible = true
	flag = true
	texture.texture = papers[next_page]
