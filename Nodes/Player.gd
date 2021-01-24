extends KinematicBody2D

class_name Player

const MIN_ANIMATION_SPEED = 0.5


var motion = Vector2()
var direction = Vector2()

export var max_velocity = 300
export var min_velocity = 100
var delta_vel = 0

export var silence_penalicer = 0.5
export var run_bonus = 1.5

export var max_weight = 5.0
var current_weight = 0.0


var current_weight_velocity = 0
var current_max_velocity = 0

var running = false
var walking = false

export var acceleration = 2500
export var deceleration = 3000

export var delta_velocity = 20

var last_direction = Vector2()

onready var pickUps = $PickUps
onready var animationPlayer = $Sprite/AnimationPlayer
onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	current_weight_velocity = max_velocity
	delta_vel = max_velocity - min_velocity



func check_input():
	var dir = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		dir += Vector2(0, -1)
	
	if Input.is_action_pressed("ui_down"):
		dir += Vector2(0, 1)
	
	if Input.is_action_pressed("ui_left"):
		dir += Vector2(-1, 0)
	
	if Input.is_action_pressed("ui_right"):
		dir += Vector2(1, 0)

	return dir.normalized()


func _physics_process(delta):
	if Input.is_action_pressed("ui_ctrl"):
		current_max_velocity = current_weight_velocity * silence_penalicer
		running = false
		walking = false
	elif Input.is_action_pressed("ui_shift"):
		running = true
		walking = true
		current_max_velocity = current_weight_velocity * run_bonus
	else:
		current_max_velocity = current_weight_velocity
		running = false
		walking = true
	
	direction = check_input()
	move(delta)
	update_animation()


func update_animation():
	var vel = motion.length()
	var speed = 1.0
	
	if abs(motion.x) > delta_velocity:
		if motion.x > 0:
			sprite.flip_h = false
		elif motion.x < 0:
			sprite.flip_h = true
	
	if vel > 0:
		speed = vel / max_velocity * (1.0 - MIN_ANIMATION_SPEED) + MIN_ANIMATION_SPEED
		
		if not running and not walking:
			animationPlayer.play("JumpSlow", -1, speed)
		else:
			animationPlayer.play("Jump", -1, speed)
			
	else:
		animationPlayer.play("Idle")
	
	


func move(delta):
	if direction == Vector2():
		motion -= motion.normalized() * deceleration * delta
	else:
		motion += direction * acceleration * delta
		last_direction = direction
	
	if motion.length() < delta_velocity:
		motion = Vector2()
	elif motion.length() > current_max_velocity:
			motion = motion.normalized() * current_max_velocity
	
	motion = move_and_slide(motion)


func update_weight_velocity():
	print(min(max_weight, current_weight))
	
	var weight_ratio = 1 - min(max_weight, current_weight) / max_weight
	current_weight_velocity = min_velocity + delta_vel * weight_ratio



func pick(pick_up):
	current_weight += pick_up.weight
	
	pick_up.visible = false
	pick_up.get_parent().remove_child(pick_up)
	pickUps.add_child(pick_up)
	
	update_weight_velocity()


func is_running():
	return running
	

func is_walking():
	return walking
