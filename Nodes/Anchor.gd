extends Position2D

onready var player = get_node("../Player")
onready var tortise = get_node("../Player")


var target_pos_x
var target_pos_y

var flag_second_target = false


func add_second_target(position):
	pass


func remove_second_target():
	flag_second_target = false


func _process(_delta):
	if not flag_second_target:
		var target = player.global_position
		target_pos_x = int(lerp(global_position.x, target.x, .035))
		target_pos_y = int(lerp(global_position.y, target.y, .035))
		global_position = Vector2(target_pos_x, target_pos_y)
	else:
		pass

