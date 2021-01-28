extends StaticBody2D


enum STATE { SLEEP, ALMOST_WAKE, WAKE, AWAKE }

var state = null

var player = null
var music_handler = null
var enemys = []

const DISTANCE_RUN = 1500
const DISTANCE_WALK = 700


onready var animationPlayer = $AnimatedSprite/AnimationPlayer

export var flag_check_vision = false

signal add_camera_target
signal remove_camera_target


func _ready():
	enemys = get_tree().get_nodes_in_group('enemy')


	player = get_tree().get_nodes_in_group('player')
	assert( player.size() > 0, "No existe ningún objeto player" )
	player = player[0]
	player.connect("picked_treasure", self, "treasure_picked")
	
	music_handler = get_tree().get_nodes_in_group('music_handler')
	assert( music_handler.size() > 0, "No existe ningún objeto music_handler" )
	music_handler = music_handler[0]
	
	change_state(STATE.SLEEP)


func change_state(new_state):
	var new_state_str = STATE.keys()[new_state]

	state = new_state

	print(new_state_str)
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


	if flag_check_vision:
		check_vision()
	
#	update()
#
#
#func _draw():
#	draw_circle(Vector2(), DISTANCE_RUN, Color(0.9,0.1,0.1,0.25))
#	draw_circle(Vector2(), DISTANCE_WALK, Color(0.1,0.1,0.9,0.25))


func treasure_picked():
	print('PICKED')
	if position.distance_to(player.position) < DISTANCE_RUN:
		change_state(STATE.ALMOST_WAKE)


func check_sound():
	var distance_to_player = position.distance_to(player.position)

	if distance_to_player < DISTANCE_WALK:
		if player.is_walking():
			change_state(STATE.ALMOST_WAKE)

	elif distance_to_player < DISTANCE_RUN:
		if player.is_running():
			change_state(STATE.ALMOST_WAKE)



func check_vision():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, player.position, [self])

	if result:
		if result.collider is Player:
			change_state(STATE.AWAKE)
			return true
	return false


func SLEEP(_delta):
	check_sound()
	animationPlayer.play("Sleep")


func ALMOST_WAKE_init():
	animationPlayer.play("AlmostWake")
	yield(animationPlayer, "animation_finished")
	if state == STATE.ALMOST_WAKE:
		animationPlayer.play("BackToSleep")
		yield(animationPlayer, "animation_finished")
		change_state(STATE.SLEEP)


func ALMOST_WAKE(_delta):
	check_sound()



func AWAKE_init():
	flag_check_vision = false
	music_handler.tortoise_awake()
	for e in enemys:
		e.set_berserk()


func AWAKE(_delta):
	animationPlayer.play("Awake")




func _on_CameraRange_body_entered(body):
	if body is Player:
		music_handler.tortoise_in_range()
		emit_signal("add_camera_target")


func _on_CameraRange_body_exited(body):
	if body is Player:
		music_handler.tortoise_out_of_range()
		emit_signal("remove_camera_target")
