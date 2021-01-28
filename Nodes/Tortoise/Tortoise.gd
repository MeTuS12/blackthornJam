extends StaticBody2D
#
#
#enum STATE { SLEEP, ALMOST_SLEEP, AWAKENING, AWAKE }
#
#var state = null
#
#var player = null
#
#const DISTANCE_WALK
#
#
#func _ready():
#	player = get_tree().get_nodes_in_group('player')
#	assert( player.size() > 0, "No existe ningún objeto Player" )
#	player = player[0]
#	change_state(STATE.SLEEP)
#
#
#func change_state(new_state):
#	var new_state_str = STATE.keys()[new_state]
#
#	state = new_state
#
#	if has_method(new_state_str + '_init'):
#		call(new_state_str + '_init')
#
#
#func end_state():
#	var state_str = STATE.keys()[state]
#
#	if has_method(state_str + '_end'):
#		call(state_str + '_end')
#
#
#func _physics_process(delta):
#
#	var state_str = STATE.keys()[state]
#
#	if has_method(state_str):
#		call(state_str, delta)
#
#	update_animation()
#
#	check_sound()
#	check_vision()
#
#	update()
#
#
#func update_animation():
#	pass
#
#
#func check_sound():
#	var distance_to_player = position.distance_to(player.position)
#
#	if distance_to_player < DISTANCE_WALK:
#		if player.is_walking():
#			if can_access(player.position):
#				update_target(player.position)
#				if state != STATE.CHASING:
#					change_state(STATE.CHASING)
#					make_sound(soundRattle)
#
#	elif distance_to_player < DISTANCE_RUN:
#		if player.is_running():
#			if can_access(player.position):
#				update_target(player.position)
#				if state != STATE.CHASING:
#					change_state(STATE.CHASING)
#					make_sound(soundRattle)
#
#
#
#func check_vision(more_range=false):
#	var real_target = null
#
#	if more_range:
#		real_target = player
#	else:
#		real_target = view_target
#
#	if real_target:
#		var space_state = get_world_2d().direct_space_state
#		var result = space_state.intersect_ray(position, real_target.position, [self])
#
#		if result:
#			if result.collider is Player:
#					update_target(result.position)
#					$Sprite.self_modulate.r = 2.0
#					if flag_hissing_attack:
#						make_sound(soundHissingAttack)
#						flag_hissing_attack = false
#
#					if state != STATE.CHASING:
#						change_state(STATE.CHASING)
#					return true
#	return false
