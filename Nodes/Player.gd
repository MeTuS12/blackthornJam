extends KinematicBody2D

class_name Player

const MIN_ANIMATION_SPEED = 0.5
const camera_default = 2.0
const camera_close = 1.5
const camera_far = 2.5

signal treasure_changed
signal weight_changed
signal picked_treasure

var motion = Vector2()
var direction = Vector2()

export var max_velocity = 350
export var min_velocity = 100
var delta_vel = 0

export var silence_penalicer = 0.5
export var run_bonus = 1.5

export var max_weight = 5.0
var current_weight = 0.0

var current_value = 0.0

var flag_can_move = true
var flag_can_die = true
var tongue_flip = false


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
onready var tongue_anim = $SpriteBase/Tongue/AnimationPlayer
onready var sprite = $SpriteBase/Sprite
onready var tongue_sprite = $SpriteBase/Tongue
onready var gameover_UI = $UI/GameOverPanel
onready var pause_menu_UI = $UI/PauseMenu
onready var insufficent_UI = $UI/InsufficentScore
onready var fade = $UI/ColorRect/AnimationPlayer
onready var JumpSound = $JumpSound
onready var DeathSound = $DeathSound

var camera_anchor = null
var music_handler = null


# Called when the node enters the scene tree for the first time.
func _ready():
	current_weight_velocity = max_velocity
	delta_vel = max_velocity - min_velocity
	
	music_handler = get_tree().get_nodes_in_group('music_handler')
	if music_handler.size() > 0:
		music_handler = music_handler[0]
	else:
		music_handler = null
	
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
		tongue_flip = false
		sprite_direction = -1
		pickUpSpawn.position.x = 10
	
	if Input.is_action_pressed("ui_right"):
		dir += Vector2(1, 0)
		sprite.flip_h = false
		tongue_flip = true
		sprite_direction = 1
		pickUpSpawn.position.x = -10

	return dir.normalized()


func set_anchor(anchor):
	self.camera_anchor = anchor


func _physics_process(delta):
#
#	if Input.is_action_just_pressed("ui_cancel") and flag_can_die:
#		pause_menu_UI.visible = true
#		get_tree().paused = true
	
	if Input.is_action_pressed("ui_ctrl"):
		current_max_velocity = current_weight_velocity * silence_penalicer
		JumpSound.volume_db = -14.0
		running = false
		walking = false
	elif Input.is_action_pressed("ui_shift"):
		walking = true
		current_max_velocity = current_weight_velocity * run_bonus
		if motion.length() > 0:
			JumpSound.volume_db = -5.0
		running = true
	else:
		current_max_velocity = current_weight_velocity
		JumpSound.volume_db = -14.0
		running = false
		walking = true
	
	if Input.is_action_just_pressed("ui_pickup_spawn"):
		throw_pick_up()
	if Input.is_action_just_pressed("ui_tongue"):
		use_tongue()
	
	direction = check_input()
	move(delta)
	check_camera_zoom()
	update_animation()


func update_animation():
	if flag_can_move:
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

func use_tongue():
	flag_can_move = false
	sprite.visible = false
	tongue_sprite.visible = true
	if !tongue_flip:
		tongue_anim.play("Tongue_Left")
	else:
		tongue_anim.play("Tongue_Right")
	yield(get_tree().create_timer(.5), "timeout")
	tongue_sprite.visible = false
	sprite.visible = true
	flag_can_move = true



func update_camera(camera_zoom):
	camera_anchor.set_zoom(camera_zoom)


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
	emit_signal("picked_treasure")


func throw_pick_up():
	var pick_ups = pickUps.get_children()
	
	if pick_ups.size() > 0:
		var throw_pick_up = pick_ups[randi() % pick_ups.size()]
		throw_pick_up.throw(self)
		emit_signal("treasure_changed", current_value)
		emit_signal("weight_changed", current_weight)

func get_pickups():
	return pickUps.get_children()


func transported():
	flag_can_move = false
	yield(get_tree().create_timer(1.0), "timeout")
	flag_can_move = true


func is_running():
	return running and motion.length_squared() > 0
	

func is_walking():
	return (walking or running) and motion.length_squared() > 0


func fade_idle():
	fade.play("Idle")

func fade_in():
	fade.play("Fade_In")

func fade_out():
	fade.play("Fade_Out")


func _on_Hurtbox_area_entered(_area):
	if flag_can_die:
		animationPlayer.play("Die")
		flag_can_die = false
		if music_handler != null:
			music_handler.end_all_sound()
		DeathSound.play()
		flag_can_move = false
		yield(get_tree().create_timer(1.0), "timeout")
		gameover_UI.visible = true
