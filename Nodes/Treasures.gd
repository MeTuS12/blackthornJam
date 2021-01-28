extends Control

var player = null

onready var crowns = $Crown
onready var weight = $Weight
onready var crown_label = $Crown/Label
onready var weight_label = $Weight/Label2

func _ready():
	
	player = get_tree().get_nodes_in_group('player')
	assert( player.size() > 0, "No existe ningún objeto Player" )
	player = player[0]
	
	player.connect("treasure_changed", self, "on_treasure_changed")
	player.connect("weight_changed", self, "on_weight_changed")

func on_treasure_changed(value):
	if value < 8:
		crown_label.visible = false
		crowns.rect_size.x = 128 * value
	else:
		crowns.rect_size.x = 1024
		crown_label.visible = true
		crown_label.text = "x" + str(value)


func on_weight_changed(value):
	if value < 8:
		weight.rect_size.x = 128 * value
		weight_label.visible = false
	else:
		weight.rect_size.x = 1024
		weight_label.visible = true
		weight_label.text = "x" + str(value)
