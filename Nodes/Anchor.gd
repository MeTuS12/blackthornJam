extends Position2D

onready var player = null
onready var target2 = null


const MIN_ZOOM = 2.0
const MAX_ZOOM = 3.0
const MIN_DIST = 1500
const MAX_DIST = 3500

const CAMERA_HEIGHT = 1080
const CAMERA_MARGIN = 1500


var flag_second_target = false
var current_zoom = MIN_ZOOM

onready var camera = $Camera2D


func _ready():
	player = get_tree().get_nodes_in_group('player')
	assert( player.size() > 0, "No existe ningún objeto player" )
	player = player[0]
	
	player.set_anchor(self)
	
	target2 = get_tree().get_nodes_in_group('tortoise')
	if target2.size() > 0:
		target2 = target2[0]
		target2.connect("add_camera_target", self, "add_second_target")
		target2.connect("remove_camera_target", self, "remove_second_target")


func add_second_target():
	flag_second_target = true
	current_zoom = MIN_ZOOM


func remove_second_target():
	flag_second_target = false
	current_zoom = MIN_ZOOM


func set_zoom(zoom):
	if not flag_second_target:
		current_zoom = zoom


func _process(_delta):
	var target = Vector2()
	var zoom = current_zoom
	
	if not flag_second_target:
		target = player.global_position
	else:
		target = (player.global_position + target2.global_position) / 2
	
		var dist = target2.global_position.distance_to(player.global_position)
		zoom = (dist + CAMERA_MARGIN) / CAMERA_HEIGHT
		zoom = max(zoom, MIN_ZOOM)
		
	
	var camera_zoom = camera.zoom.x
	var interpolate = .035
	var new_zoom = camera_zoom * (1 - interpolate) + zoom * interpolate
	
	camera.zoom = Vector2(new_zoom, new_zoom)
#	print(zoom)
#	print(camera.zoom.x)
	
	global_position.x = int(lerp(global_position.x, target.x, .035))
	global_position.y = int(lerp(global_position.y, target.y, .035))











