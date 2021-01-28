extends KinematicBody2D

class_name Enemy


enum STATE { WAIT, GO_TO_POINT, CHASING, LOST_TARGET, BERSERK_MODE }

const DISTANCE_RUN = 1500
const DISTANCE_WALK = 700

var motion = Vector2()
var direction = Vector2()

export var max_velocity = 250
var current_max_velocity = 0

export var run_bonus = 2.0

export var acceleration = 2500
export var deceleration = 3000

export var delta_velocity = 10

export var wait_time = 2.0
export var target_min_distance = 50
export var path_point_min_distance = 50
export var cant_access_distance = 100


#onready var pickUps = $PickUps

var is_aware = false

var attractors = []
var repellers = []

var walk_points = []
var target_point = null
var target_pickup_point = null
var next_path_point = null

var navigation = null
var path = null
var player = null
var music_handler = null
var pickups = []

var view_target = null
var view_target_pickup = null
#var vis_color = Color(.867,.91,.247,.1)
#var ear_color = Color(.247,.91,.247,.1)
#var target_min_distance_color = Color(.947,.91,.247,.1)

var state = null


onready var sprite = $Sprite
onready var animationPlayer = $Sprite/AnimationPlayer
onready var viewzone = $ViewZone

onready var soundHissing = $Hissing
onready var soundHissingAttack = $HissingAttack
onready var soundRattle = $Rattle
onready var moveSound = $MoveSound

var flag_hissing_attack = true
signal make_sound (position)

# Called when the node enters the scene tree for the first time.
func _ready():
	walk_points = get_tree().get_nodes_in_group('walk_point')
	assert( walk_points.size() >= 4, "Tienen que existir al menos 4 puntos de objetivo para los enemigos" )
	
	pickups = get_tree().get_nodes_in_group('pickup')
	
	navigation = get_tree().get_nodes_in_group('navigation')
	assert( navigation.size() > 0, "No existe ningún objeto Navigation2D (tiene que pertenecer al grupo 'navigation')" )
	navigation = navigation[0]
	
	player = get_tree().get_nodes_in_group('player')
	assert( player.size() > 0, "No existe ningún objeto Player" )
	player = player[0]
	
	music_handler = get_tree().get_nodes_in_group('music_handler')
	assert( music_handler.size() > 0, "No existe ningún objeto music_handler" )
	music_handler = music_handler[0]
	
	make_sound_each_random_time()
	change_state(STATE.WAIT)


func make_sound_each_random_time():
	yield(get_tree().create_timer(randf() * 5 + 5), "timeout")
	
	soundHissing.play()
	make_sound_each_random_time()
	
	if flag_hissing_attack == false:
		flag_hissing_attack = true


func make_sound(sound):
	sound.play()
	emit_signal("make_sound", position)


func change_state(new_state):
	var new_state_str = STATE.keys()[new_state]
	
	if state != new_state:
		print(new_state_str)
		
		state = new_state
		
		if has_method(new_state_str + '_init'):
			call(new_state_str + '_init')


func end_state():
	var state_str = STATE.keys()[state]
	
	if has_method(state_str + '_end'):
		call(state_str + '_end')


func _physics_process(delta):
	
	var state_str = STATE.keys()[state]
	
	if has_method(state_str):
		call(state_str, delta)
	
	update_animation()
	
	check_sound()
	check_vision()
	check_pickup()
	
	if motion.length_squared() > 0:
		moveSound.volume_db = -3.0
	else:
		moveSound.volume_db = -80.0


func update_target(position):
	target_point = position



func check_sound():
	var distance_to_player = position.distance_to(player.position)
	
	if distance_to_player < DISTANCE_WALK:
		if player.is_walking():
			if can_access(player.position):
				update_target(player.position)
				if state != STATE.CHASING:
					change_state(STATE.CHASING)
					make_sound(soundRattle)
	
	elif distance_to_player < DISTANCE_RUN:
		if player.is_running():
			if can_access(player.position):
				update_target(player.position)
				if state != STATE.CHASING:
					change_state(STATE.CHASING)
					make_sound(soundRattle)


#func _draw():
#	draw_circle(Vector2(), DISTANCE_RUN, Color(0.9,0.1,0.1,0.25))
#	draw_circle(Vector2(), DISTANCE_WALK, Color(0.1,0.1,0.9,0.25))
#
#	if path != null:
#		var prevPoint = Vector2()
#
#		if target_point != null:
#			var targetPos = target_point - position
#			draw_line(targetPos, targetPos + Vector2(0, -30), Color(0, 255, 0), 10)
#
#		for point in path:
#			draw_line(prevPoint, point - position, Color(255, 0, 0), 1)
#			prevPoint = point - position
#			draw_line(prevPoint, prevPoint + Vector2(0, -10), Color(0, 0, 255), 1)


func check_vision(more_range=false):
	var real_target = null
	
	if more_range:
		real_target = player
	else:
		real_target = view_target
	
	if real_target:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position, real_target.position, [self])
		
		if result:
			if result.collider is Player:
					update_target(result.position)
					
					if flag_hissing_attack:
						make_sound(soundHissingAttack)
						flag_hissing_attack = false
						
					if state != STATE.CHASING:
						change_state(STATE.CHASING)
					return true
	return false


func check_pickup():
#	var distance_to_player = position.distance_to(player.position)
	
	for p in pickups:
		if is_instance_valid(p) and p.player_flag and p.enemy_flag:
			if position.distance_to(p.position) < DISTANCE_RUN:
				if can_access(p.position):
					update_target(p.position)
					change_state(STATE.CHASING)


func WAIT_init():
	yield(get_tree().create_timer(wait_time), "timeout")
	is_aware = false
	end_state()


#func WAIT(_delta):
#	check_sound()


func WAIT_end():
	change_state(STATE.GO_TO_POINT)


func GO_TO_POINT_init():
	walk_points.sort_custom(self, "closest_compare")
	randomize()
	update_target( walk_points[ randi() % 3 + 1 ].position )


func closest_compare(a, b):
	return position.distance_squared_to(a.position) < position.distance_squared_to(b.position)


func GO_TO_POINT(_delta):
	move_in_path(_delta)



func can_access(target, path=null):
	if path == null:
		path = navigation.get_simple_path(position, target)
	
	if path.size() > 0 and path[-1].distance_to(target) < cant_access_distance:
		return true
	
	return false


func move_in_path(_delta, only_player=false):
	var target = null
	
	if not only_player:
		if target_point == null and target_pickup_point == null:
			return
		
		if target_pickup_point != null:
			target = target_pickup_point
		else:
			target = target_point
	else:
		target = player.position
	
	path = navigation.get_simple_path(position, target)
	
	if not can_access(target, path) and not only_player:
		change_state(STATE.WAIT)
		return
	
	popPathPoint()
	
	
	if next_path_point == null or position.distance_to(next_path_point) < target_min_distance:
		if not popPathPoint():
			if position.distance_to(target_point) < target_min_distance  and not only_player:
				if state == STATE.CHASING:
					music_handler.snake_stop()
				change_state(STATE.WAIT)
				return
			else:
				next_path_point = target_point
	
	direction = position.direction_to(next_path_point).normalized()
	move(_delta)


func LOST_TARGET_init():
	if not check_vision(true):
		change_state(STATE.WAIT)


func popPathPoint():
	if path.size() > 0:
		next_path_point = path[0]
		path.remove(0)
		
		while position.distance_to(next_path_point) < path_point_min_distance and not path.empty():
			next_path_point = path[0]
			path.remove(0)
		
		if position.distance_to(next_path_point) < path_point_min_distance and path.empty():
			next_path_point = null
			return false
		
		return true
	return false



func GO_TO_POINT_end():
	change_state(STATE.GO_TO_POINT)



func update_animation():
	var vel = motion.length()
	
	if motion.x < 0:
#		viewzone.position.x = -736
		viewzone.scale.x = -1
		sprite.flip_h = true
	elif motion.x > 0:
#		viewzone.position.x = 776
		viewzone.scale.x = 1
		sprite.flip_h = false
	
	if vel > 0:
		if is_aware:
			animationPlayer.play("Walk", -1, 1.0)
		else:
			animationPlayer.play("Walk", -1, 0.7)
	else:
		animationPlayer.play("Idle")


func move(delta):
	if is_aware:
		current_max_velocity = max_velocity * run_bonus
	else:
		current_max_velocity = max_velocity

	
	if direction == Vector2():
		motion -= motion.normalized() * deceleration * delta
		
		if motion.length() < delta_velocity:
			motion = Vector2()
	else:
		motion += direction * acceleration * delta
		
		if motion.length() > current_max_velocity:
			motion = motion.normalized() * current_max_velocity
	
	motion = move_and_slide(motion)



func AWARE_init():
	path = navigation.get_simple_path(position, target_point)



func AWARE(_delta):
	path = navigation.get_simple_path(position, target_point)
	move_in_path(_delta)
	is_aware = true



func CHASING_init():
	music_handler.snake_pursuing()



func CHASING(_delta):
	path = navigation.get_simple_path(position, target_point)
	move_in_path(_delta)
	is_aware = true



func BERSERK_MODE(_delta):
	move_in_path(_delta, true)
	is_aware = true


func set_berserk():
	change_state(STATE.BERSERK_MODE)


func is_going_after_player():
	pass


func _on_ViewZone_body_entered(body):
	if body is Player:
		view_target = body


func _on_ViewZone_body_exited(body):
	if body == view_target:
		view_target = null

