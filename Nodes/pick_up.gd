extends KinematicBody2D

class_name PickUp

export var throw_displacement = Vector2(200, 130)

export var value = 2
export var weight = 1

var player_flag = true
var enemy_flag = false


var motion = Vector2()
var acc = Vector2()
var energy = Vector2()


var y_floor = 0

var gravity = 4000
var throw_force = 80000
var throw_dir = Vector2(-1, -2).normalized()


onready var collisionShape = $CollisionShape2D



func _ready():
	pass


func _physics_process(delta):
	move(delta)


func pick(body):
	if body.name == "Player":
		body.current_weight += weight
		body.current_value += value
		Globals.actual_score = body.current_value
		
#		print(body.current_value)
#		print(value)
#		print(name)
		
		visible = false
		get_parent().remove_child(self)
		body.pickUps.add_child(self)
		body.update_weight_velocity()
		enemy_flag = false
		
		collisionShape.disabled = true


func throw(player):
	player.current_weight -= weight
	player.current_value -= value
	player.pickUps.remove_child(self)
	Globals.actual_score = player.current_value
	
	player.get_parent().add_child(self)
	
	visible = true
	
	player.update_weight_velocity()
	
#	var ini_pos = player.pickUpSpawn.global_position
#	global_position = player.pickUpSpawn.global_position
	var ini_pos = player.global_position
	global_position = player.global_position
	
	collisionShape.disabled = false
	acc = throw_dir * throw_force
	acc.x = acc.x * player.sprite_direction
	y_floor = ini_pos.y + throw_displacement.y
	
	yield(get_tree().create_timer(1.0), "timeout")
	player_flag = true
	enemy_flag = true


func move(delta):
	if motion.length_squared() > 10 or acc.length_squared() > 0:
		motion += delta * acc
		acc = Vector2()
		motion += delta * Vector2(0, gravity)

		motion = move_and_slide(motion)
		
		if motion.y == 0:
			motion = Vector2()
			
		if position.y > y_floor:
			motion = Vector2()
			player_flag = true
			enemy_flag = true
	



func _on_Area2D_body_entered(body):
	if player_flag:
		if body.name == "Player":
			player_flag = false
			$PickUpSound.play()
			body.call_deferred('pick', self)
		elif enemy_flag and body is Enemy:
			queue_free()
