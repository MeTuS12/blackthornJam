extends Position2D

onready var player = get_node("../Player")
onready var target2 = get_node("../Player")



var flag_second_target = false


func add_second_target(position):
	pass


func remove_second_target():
	flag_second_target = false


func calc_zoom():
	pass


func _process(_delta):
	var target = Vector2()
	
	if not flag_second_target:
		target = player.global_position
	else:
		target = player.global_position # Media con el target 2
	
	global_position.x = int(lerp(global_position.x, target.x, .035))
	global_position.y = int(lerp(global_position.y, target.y, .035))

