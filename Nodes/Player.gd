extends KinematicBody2D

class_name Player

const MIN_ANIMATION_SPEED = 0.5
const camera_default = Vector2(2, 2)
const camera_close = Vector2(1.5, 1.5)
const camera_far = Vector2(2.5, 2.5)

var current_camera_zoom = Vector2()

signal treasure_changed
signal weight_changed

var motion = Vector2()
var direction = Vector2()

export var max_velocity = 300
export var min_velocity = 100
var delta_vel = 0

export var silence_penalicer = 0.5
export var run_bonus = 1.5

export var max_weight = 5.0
var current_weight = 0.0

var current_value = 0.0

var flag_can_move = true


var current_weight_velocity = 0
var current_max_velocity = 0

var running = false
var walking = false

export var acceleration = 2500
export var deceleration = 3000

export var delta_velocity = 20

var sprite_direction = 0

var cameraTween = null

onready var pickUps = $PickUps
onready var pickUpSpawn = $PickupSpawn
onready var animationPlayer = $SpriteBase/Sprite/AnimationPlayer
onready var sprite = $SpriteBase/Sprite
onready var camera = $Camera2D
onready var gameover_UI = $UI/GameOverPanel
onready var pause_menu_UI = $UI/PauseMenu
onready var insufficent_UI = $UI/InsufficentScore
onready var fade = $UI/ColorRect/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	current_weight_velocity = max_velocity
	delta_vel = max_velocity - min_velocity
	cameraTween = Tween.new()
	camera.add_child(cameraTween)
	if Globals.fade_flag:
		get_tree().paused = true
		yield(get_tree().create_timer(.3), "timeout")
		fade_out()
		yield(get_tree().create_timer(.5), "timeout")
		get_tree().paused = false

func check_input():
	var dir = Vector2()
	
	if not flag_can_move:
		return dir
	
	if Input.is_action_pressed("ui_up"):
		dir += Vector2(0, -1)
	
	if Input.is_action_pressed("ui_down"):
		dir += Vector2(0, 1)
	
	if Input.is_action_pressed("ui_left"):
		dir += Vector2(-1, 0)
		sprite.flip_h = true
		sprite_direction = -1
		pickUpSpawn.position.x = 10
	
	if Input.is_action_pressed("ui_right"):
		dir += Vector2(1, 0)
		sprite.flip_h = false
		sprite_direction = 1
		pickUpSpawn.position.x = -10

	return dir.normalized()


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel") and Globals.pause_flag:
		pause_menu_UI.visible = true
		get_tree().paused = true
	
	if Input.is_action_pressed("ui_ctrl"):
		current_max_velocity = current_weight_velocity * silence_penalicer
		running = false
		walking = false
	elif Input.is_action_pressed("ui_shift"):
		walking = true
		current_max_velocity = current_weight_velocity * run_bonus
		if motion.length() > 0:
			running = true
	else:
		current_max_velocity = current_weight_velocity
		running = false
		if motion.length() > 0:
			walking = true
	
	if Input.is_action_just_pressed("ui_pickup_spawn"):
		throw_pick_up()
	
	
	direction = check_input()
	move(delta)
	check_camera_zoom()
	update_animation()


func update_animation():
	var vel = motion.length()
	var speed = 1.0
	
	if vel > 0:
		speed = vel / max_velocity * (1.0 - MIN_ANIMATION_SPEED) + MIN_ANIMATION_SPEED
		
		if not running and not walking:
			animationPlayer.play("JumpSlow", -1, speed)
		else:
			animationPlayer.play("Jump", -1, speed)
			
	else:
		animationPlayer.play("Idle")


func update_camera(camera_zoom):
	if current_camera_zoom != camera_zoom:
		cameraTween.interpolate_property(camera, "zoom", camera.zoom, camera_zoom, .7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		cameraTween.start()
		current_camera_zoom = camera_zoom


func check_camera_zoom():
	if Input.is_action_pressed("ui_shift") and motion.length() > 0:
		update_camera(camera_close)
	elif Input.is_action_pressed("ui_ctrl"):
		update_camera(camera_far)
	else:	#if not Input.is_action_pressed("ui_ctrl"):
		update_camera(camera_default)


func move(delta):
	if direction == Vector2():
		motion -= motion.normalized() * deceleration * delta
	else:
		motion += direction * acceleration * delta
	
	if motion.length() < delta_velocity:
		motion = Vector2()
	elif motion.length() > current_max_velocity:
			motion = motion.normalized() * current_max_velocity
	
	motion = move_and_slide(motion)




func update_weight_velocity():
#	print(min(max_weight, current_weight))
	
	var weight_ratio = 1 - min(max_weight, current_weight) / max_weight
	current_weight_velocity = min_velocity + delta_vel * weight_ratio



func pick(pick_up):
	pick_up.pick(self)
	emit_signal("treasure_changed", current_value)
	emit_signal("weight_changed", current_weight)


func throw_pick_up():
	var pick_ups = pickUps.get_children()
	
	if pick_ups.size() > 0:
		var throw_pick_up = pick_ups[randi() % pick_ups.size()]
		throw_pick_up.throw(self)
		emit_signal("treasure_changed", current_value)
		emit_signal("weight_changed", current_weight)


func transported():
	flag_can_move = false
	yield(get_tree().create_timer(1.0), "timeout")
	flag_can_move = true


func is_running():
	return running
	

func is_walking():
	return walking

func fade_idle():
	fade.play("Idle")

func fade_in():
	fade.play("Fade_In")

func fade_out():
	fade.play("Fade_Out")

#func fade_idle():
#	fade.play("Idle")

func _on_Hurtbox_area_entered(_area):
	print('AAAA')
	flag_can_move = false
	yield(get_tree().create_timer(1.0), "timeout")
	gameover_UI.visible = true
