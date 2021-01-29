extends CenterContainer

var player = null

onready var music = $TextureRect/MusicSilder
onready var sfx = $TextureRect/SFXSlider

func _ready():
	music.value = Globals.music_volume
	sfx.value = Globals.sfx_volume
	player = get_tree().get_nodes_in_group('player')
	player = player[0]
	if !Globals.pause_flag:
		$TextureRect/VBoxContainer/HBoxContainer/VBoxContainer/MainMenu.visible = false
		$TextureRect/VBoxContainer/HBoxContainer/VBoxContainer/Restart.visible = false

func _physics_process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx.value)
	Globals.music_volume = music.value
	Globals.sfx_volume = sfx.value
	
	if Input.is_action_just_pressed("ui_cancel") and player.flag_can_die:
		visible = !visible
		get_tree().paused = !get_tree().paused



func _on_Resume_pressed():
	visible = false
	get_tree().paused = false


func _on_MainMenu_pressed():
	visible = false
	player.fade_in()
	get_tree().paused = true
	yield(get_tree().create_timer(.5), "timeout")
	Globals.fade_flag = true
	Globals.pause_flag = false
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Restart_pressed():
	visible = false
	player.fade_in()
	get_tree().paused = true
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")


func _on_Exit_pressed():
	visible = false
	player.fade_in()
	get_tree().paused = true
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().quit()
