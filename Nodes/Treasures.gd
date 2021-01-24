extends Control

var player = null

onready var texture = $TextureRect

func _ready():
	
	player = get_tree().get_nodes_in_group('player')
	assert( player.size() > 0, "No existe ningún objeto Player" )
	player = player[0]
	
	player.connect("treasure_changed", self, "on_treasure_changed")

func on_treasure_changed(value):
	texture.rect_size.x = 4000 * value
