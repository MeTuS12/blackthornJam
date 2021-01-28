extends CenterContainer

var player = null

onready var music = $TextureRect/MusicSilder
onready var sfx = $TextureRect/SFXSlider

func _ready():
	player = get_tree().get_nodes_in_group('player')
	player = player[0]

func _physics_process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx.value)


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
