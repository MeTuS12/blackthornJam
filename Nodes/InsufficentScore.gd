extends CenterContainer

onready var actual = $TextureRect/VBoxContainer/ActualScore
onready var required = $TextureRect/VBoxContainer/RequiredScore
onready var continue_label = $TextureRect/VBoxContainer/Continue
onready var okay_button = $TextureRect/VBoxContainer/HBoxContainer/VBoxContainer/Okay
onready var congrat = $TextureRect/VBoxContainer/Congratulations

var player = null


func _ready():
# warning-ignore:return_value_discarded
	Globals.connect("score", self, "on_score")
	player = get_tree().get_nodes_in_group('player')
	player = player[0]

func on_score():
	if Globals.actual_score < Globals.min_score:
		okay_button.text = "CONTINUE"
		continue_label.visible = false
		actual.text = "YOU HAVE STOLEN TREASURES WORTH OF: " + str(Globals.actual_score) + " CROWNS"
		required.text = "YOU NEED TO STEAL TREASURES WORTH OF: " + str(Globals.min_score) + " CROWNS OR MORE TO LEAVE THE CASTLE"
	else:
		congrat.visible = true
		okay_button.text = "LEAVE"
		continue_label.visible = true
		actual.text = "YOU COMPLETED THE QUEST WITH TREASURES \nWORTH OF " + str(Globals.actual_score) + " CROWNS!"
		required.text = "YOU ESCAPED SAFE AND SOUND WITH GREAT TREASURES"


func _on_Button_pressed():
	if Globals.actual_score < Globals.min_score:
		get_tree().paused = false
		visible = false
	else:
		_on_Left_pressed()


func _on_Left_pressed():
	Globals.score_flag = true
	update_score()
	visible = false
	player.fade_in()
	get_tree().paused = true
	yield(get_tree().create_timer(.5), "timeout")
	Globals.fade_flag = true
	Globals.pause_flag = false
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")


func update_score():
	var save_data = SaveAndLoad.load_data_from_file()
	
	if Globals.easy:
		if Globals.actual_score > save_data.easy:
			save_data.easy = Globals.actual_score
			SaveAndLoad.save_data_to_file(save_data)
	if Globals.hard:
		if Globals.actual_score > save_data.hard:
			save_data.hard = Globals.actual_score
			SaveAndLoad.save_data_to_file(save_data)
	if Globals.very_hard:
		if Globals.actual_score > save_data.very:
			save_data.very = Globals.actual_score
			SaveAndLoad.save_data_to_file(save_data)
