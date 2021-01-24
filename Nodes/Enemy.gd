extends KinematicBody2D

class_name Enemy


enum STATE { WAIT, GO_TO_POINT, AWARE, CHASING, LOST_TARGET }

const DISTANCE_RUN = 300
const DISTANCE_WALK = 100

var motion = Vector2()
var direction = Vector2()

export var max_velocity = 100
var current_max_velocity = 0

export var run_bonus = 1.5

export var acceleration = 2500
export var deceleration = 3000

export var delta_velocity = 3

export var wait_time = 1.0
export var target_min_distance = 50


#onready var pickUps = $PickUps

var is_aware = false

var attractors = []
var repellers = []

var walk_points = []
var target_point = null
var next_path_point = null

var navigation = null
var path = null
var player = null

var view_target = null
var hit_pos = null
var vis_color = Color(.867,.91,.247,.1)
var ear_color = Color(.247,.91,.247,.1)

var state = STATE.WAIT



# Called when the node enters the scene tree for the first time.
func _ready():
	walk_points = get_tree().get_nodes_in_group('walk_point')
	assert( walk_points.size() >= 4, "Tienen que existir al menos 4 puntos de objetivo para los enemigos" )
	
	navigation = get_tree().get_nodes_in_group('navigation')
	assert( navigation.size() > 0, "No existe ningún objeto Navigation2D (tiene que pertenecer al grupo 'navigation')" )
	navigation = navigation[0]
	
	player = get_tree().get_nodes_in_group('player')
	assert( player.size() > 0, "No existe ningún objeto Navigation2D (tiene que pertenecer al grupo 'player')" )
	player = player[0]
	
	change_state(STATE.WAIT)


func change_state(new_state):
	var new_state_str = STATE.keys()[new_state]
	
	state = new_state
	
	if has_method(new_state_str + '_init'):
#		print(new_state_str + '_init')
		call(new_state_str + '_init')


func end_state():
	var state_str = STATE.keys()[state]
	
	if has_method(state_str + '_end'):
#		print(state_str + '_end')
		call(state_str + '_end')


func _physics_process(delta):
	var state_str = STATE.keys()[state]
	
	if has_method(state_str):
		call(state_str, delta)
	
	if view_target:
		aim()



func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, view_target.position, [self])
	
	if result:
		hit_pos = result.position
		if result.collider.name == "Player":
			$Sprite.self_modulate.r = 2.0



func _draw():
#	 Lejos
	draw_circle(Vector2(), 300, vis_color)
#	 Cerca
	draw_circle(Vector2(), 100, ear_color)



func WAIT_init():
	yield(get_tree().create_timer(wait_time), "timeout")
	is_aware = false
	end_state()


func WAIT(_delta):
	check_sound()


func WAIT_end():
	change_state(STATE.GO_TO_POINT)



func check_sound():
	var distance_to_player = position.distance_to(player.position)
	
	if distance_to_player < DISTANCE_WALK:
		if player.is_running():
			target_point = player.position
			change_state(STATE.AWARE)
	
	elif distance_to_player < DISTANCE_RUN:
		if player.is_running():
			target_point = player.position
			change_state(STATE.AWARE)


func GO_TO_POINT_init():
	walk_points.sort_custom(self, "closest_compare")
	randomize()
	target_point = walk_points[ randi() % 3 + 1 ]
	path = navigation.get_simple_path(position, target_point.position)


func closest_compare(a, b):
	return position.distance_squared_to(a.position) < position.distance_squared_to(b.position)


func GO_TO_POINT(_delta):
	check_sound()
	move_in_path(_delta)



func move_in_path(_delta):
	if next_path_point == null or position.distance_to(next_path_point) < target_min_distance:
		if not popPathPoint():
			change_state(STATE.WAIT)
			return
	
	direction = position.direction_to(next_path_point).normalized()
	move(_delta)



func popPathPoint():
	if path.size() > 0:
		next_path_point = path[0]
		path.remove(0)
		return true
	return false



func GO_TO_POINT_end():
	change_state(STATE.GO_TO_POINT)



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
	move_in_path(_delta)
	is_aware = true



func CHASING_init():
	path = navigation.get_simple_path(position, hit_pos)



func CHASING(_delta):
	move_in_path(_delta)
	is_aware = true


func _on_ViewZone_body_entered(body):	
	if body is Player:
		view_target = body


func _on_ViewZone_body_exited(body):
	if body == view_target:
		view_target = null
		$Sprite.self_modulate.r = 1.0