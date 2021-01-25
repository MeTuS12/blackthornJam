extends Camera2D

var current_camera_zoom = Vector2()
var tween = null
var player = null

func _ready():
	tween = Tween.new()
	self.add_child(tween)
	
	player = get_tree().get_nodes_in_group('player')
	assert( player.size() > 0, "No existe ningún objeto Player" )
	player = player[0]
	
	player.connect("camera_changed", self, "change_zoom")

func change_zoom(camera_zoom):
	if current_camera_zoom != camera_zoom:
		tween.interpolate_property(self, "zoom", zoom, camera_zoom, .7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		current_camera_zoom = camera_zoom
