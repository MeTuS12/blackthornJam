extends Node2D


export(NodePath) var stairs_pair

var pair = null
var flag = true

onready var spawn_position = $SpawnPosition


func _ready():
	var assignedPair = get_node(stairs_pair)
#	print(assignedPair)
	
	if not assignedPair == null:
		assert(assignedPair.is_in_group("spawn"), "Las escaleras " + name + " están asociadas a un objeto que no es tipo Stairs")
		pair = assignedPair
		pair.set_pair(self)
#		print(pair)


func set_pair(pair):
	self.pair = pair


func disable():
	flag = false
	yield(get_tree().create_timer(2.0), "timeout")
	flag = true


func get_spawn_position():
	return spawn_position.global_position



func _on_Area2D_body_entered(body):
	if flag:
		if body is Player:
			if pair != null:
				body.global_position = pair.get_spawn_position()
				body.motion = Vector2()
				$AudioStreamPlayer.play()
				pair.disable()


func _on_Area2D_body_exited(body):
	if body is Player:
		flag = true
