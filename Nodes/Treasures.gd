extends Control

var player = null

onready var crowns = $Crown
onready var weight = $Weight

func _ready():
	
	player = get_tree().get_nodes_in_group('player')
	assert( player.size() > 0, "No existe ningún objeto Player" )
	player = player[0]
	
	player.connect("treasure_changed", self, "on_treasure_changed")
	player.connect("weight_changed", self, "on_weight_changed")

func on_treasure_changed(value):
	crowns.rect_size.x = 128 * value


func on_weight_changed(value):
	weight.rect_size.x = 128 * value
