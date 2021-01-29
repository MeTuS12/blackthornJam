extends CenterContainer

onready var actual = $TextureRect/VBoxContainer/ActualScore
onready var required = $TextureRect/VBoxContainer/RequiredScore
onready var continue_label = $TextureRect/VBoxContainer/Continue
onready var okay_button = $TextureRect/VBoxContainer/HBoxContainer/VBoxContainer/Okay
onready var congrat = $TextureRect/VBoxContainer/Congratulations
onready var victory_audio = $VictorySound

var music_handler = null

var player = null


func _ready():
# warning-ignore:return_value_discarded
	Globals.connect("score", self, "on_score")
	player = get_tree().get_nodes_in_group('player')
	player = player[0]
	
	music_handler = get_tree().get_nodes_in_group('music_handler')
	if music_handler.size() > 0:
		music_handler = music_handler[0]
	else:
		music_handler = null

func on_score():
	if Globals.actual_score < Globals.min_score:
		okay_button.text = "CONTINUE"
		continue_label.visible = false
		actual.text = "YOU HAVE STOLEN TREASURES WORTH OF: " + str(Globals.actual_score) + " CROWNS"
		required.text = "\nYOU NEED TO STEAL TREASURES WORTH OF: " + str(Globals.min_score) + " CROWNS OR MORE TO LEAVE THE CASTLE"
	else:
		if music_handler != null:
			music_handler.end_all_sound()
		victory_audio.play()
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
	var pickups = player.get_pickups()
	
	if Globals.easy:
		if Globals.actual_score > save_data[0].easy:
			save_data[0].easy = Globals.actual_score
			SaveAndLoad.save_data_to_file(save_data)
	if Globals.hard:
		if Globals.actual_score > save_data[0].hard:
			save_data[0].hard = Globals.actual_score
			SaveAndLoad.save_data_to_file(save_data)
	if Globals.very_hard:
		if Globals.actual_score > save_data[0].very:
			save_data[0].very = Globals.actual_score
			SaveAndLoad.save_data_to_file(save_data)
	
	for p in pickups:
		if save_data[1].keys().has(p.ID):
			if save_data[1][p.ID] == false:
				save_data[1][p.ID] = true
				SaveAndLoad.save_data_to_file(save_data)
			else:
				return
