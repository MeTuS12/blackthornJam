extends Position2D

onready var player = get_node("../Player")


var target_pos_x
var target_pos_y


func _process(_delta):
	var target = player.global_position
	target_pos_x = int(lerp(global_position.x, target.x, .035))
	target_pos_y = int(lerp(global_position.y, target.y, .035))
	global_position = Vector2(target_pos_x, target_pos_y)
