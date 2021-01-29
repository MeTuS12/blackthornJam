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
var info4 = "YOU CAN THROW YOUR TREASURE,\nBUT THE GUARDS WILL TAKE IT"
var paper5 = load("res://Assets/intro/paper5.png")
var info5 = "ONCE YOU HAVE THE TREASURE,\nLEAVE WITHOUT BEING CAUGHT"


var papers = [paper0, paper1, paper2, paper3, paper4, paper5]
var infos = [info0, info1, info2, info3, info4, info5]
var next_page = 0
var flag = true


onready var space_label = $CanvasLayer/CenterContainer/Control/PressKey
onready var texture = $CanvasLayer/CenterContainer/TextureRect
onready var infoLabel = $CanvasLayer/CenterContainer/Control/Info
onready var audio = $AudioStreamPlayer
onready var title = $CanvasLayer/CenterContainer/Control/Title


func _input(event):
#	VisualServer.set_default_clear_color(Color("#2a2c30")) cambio el color para probar
	VisualServer.set_default_clear_color(Color("#111312"))
	if Input.is_action_just_pressed("ui_cancel"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://MainMenu.tscn")
	if flag and event is InputEventKey or InputEventMouse and event.is_pressed():
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
	space_label.rect_position.x = -114.345
	space_label.rect_position.y = -282.354
	if next_page < papers.size() -1:
		texture.texture = papers[next_page]
		infoLabel.text = infos[next_page]
