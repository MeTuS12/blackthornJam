extends Node2D

var paper0 = load("res://Assets/intro/paper0.png")
var info0 = ""
var paper1 = load("res://Assets/intro/paper1.png")
var info1 = "YOU HAVE TO STEAL\nAS MUCH TREASURE AS YOU CAN"
var paper2 = load("res://Assets/intro/paper2.png")
var info2 = "BEWARE OF THE GUARDS,\nTHEY WILL TRY TO CATCH YOU"
var paper3 = load("res://Assets/intro/paper3.png")
var info3 = "THE MORE WEIGHT YOU CARRY,\nTHE SLOWER YOU MOVE"
var paper4 = load("res://Assets/intro/paper4.png")
var info4 = "ONCE YOU HAVE THE TREASURE,\nLEAVE WITHOUT BEING CAUGHT"


var papers = [paper0, paper1, paper2, paper3, paper4]
var infos = [info0, info1, info2, info3, info4]
var next_page = 0
var flag = true

onready var space_label = $CanvasLayer/CenterContainer/TextureRect/Label
onready var texture = $CanvasLayer/CenterContainer/TextureRect
onready var infoLabel = $CanvasLayer/CenterContainer/TextureRect/Info
onready var audio = $AudioStreamPlayer

func _input(event):
	VisualServer.set_default_clear_color(Color("#2a2c30"))
	if flag and event is InputEventKey and event.is_pressed():
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
	infoLabel.text = infos[next_page]
