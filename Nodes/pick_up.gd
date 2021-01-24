extends Node2D

class_name PickUp

export var throw_displacement = Vector2(200, 130)

export var value = 2
export var weight = 1

var player_flag = true
var enemy_flag = false

func _ready():
	pass



func pick(body):
	if body.name == "Player":
		visible = false
		get_parent().remove_child(self)
		body.pickUps.add_child(self)
		body.update_weight_velocity()
		enemy_flag = false


func throw(player):
	player.current_weight -= self.weight
	player.pickUps.remove_child(self)
	
	player.get_parent().add_child(self)
	
	visible = true
	
	player.update_weight_velocity()
	
	global_position = player.pickUpSpawn.global_position + player.sprite_direction * throw_displacement
	
	var tween = Tween.new()
	add_child(tween)
	
	var ini_pos = player.pickUpSpawn.global_position
	
	tween.interpolate_property(self, "global_position:x",
		ini_pos.x, 
		ini_pos.x + -1 * player.sprite_direction * throw_displacement.x, 
		1.0,
		Tween.TRANS_CIRC, Tween.EASE_OUT)
	
	tween.interpolate_property(self, "global_position:y",
		ini_pos.y, 
		ini_pos.y + throw_displacement.y, 
		1.0,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	
	tween.start()

	yield(tween, "tween_completed")
	player_flag = true
	enemy_flag = true
	
	



func _on_Area2D_body_entered(body):
	if player_flag:
		if body.name == "Player":
			player_flag = false
			body.call_deferred('pick', self)
		elif enemy_flag and body is Enemy:
			queue_free()
