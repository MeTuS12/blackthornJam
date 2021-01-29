extends Node



const NORMAL_VOLUME = -5.0
const SNAKE_VOLUME = -2.0
const SHOUT_DOWN_VOLUME = -80.0

onready var gameplay_stream = $GameplayStream 
onready var snakes_stream = $SnakesStream
onready var tortoise_stream = $TortoiseStream

onready var tween = $Tween

var flag_is_awake = false

var flag_snake_is_playing = false
var flag_sound_ended = false

var n_snakes = 0
var snakes = []


func set_volume(stream, volume):
	if not flag_sound_ended:
		tween.interpolate_property(stream, "volume_db", stream.volume_db, volume, 1.0,
			Tween.TRANS_EXPO, Tween.EASE_OUT)
		tween.start()
	


func _ready():
	gameplay_stream.volume_db = NORMAL_VOLUME
	snakes_stream.stop()


func snake_pursuing(snake):
	print('Pursuing')
	print(flag_is_awake)
	print(flag_snake_is_playing)
	
	if not flag_is_awake and not flag_snake_is_playing:
		if not snakes.has(snake):
			snakes.append(snake)
		
		print('SET VOLUME')
		set_volume(snakes_stream, SNAKE_VOLUME)
		flag_snake_is_playing = true
	print(snakes.size())



func snake_stop(snake):
	var i = snakes.find(snake)
	
	if i > -1:
		snakes.remove(i)
	
	if snakes.size() == 0:
		set_volume(snakes_stream, SHOUT_DOWN_VOLUME)
		flag_snake_is_playing = false


func tortoise_in_range():
	gameplay_stream.stop()
#	set_volume(gameplay_stream, SHOUT_DOWN_VOLUME)


func tortoise_out_of_range():
	gameplay_stream.play()
#	set_volume(gameplay_stream, NORMAL_VOLUME)


func end_all_sound():
	set_volume(gameplay_stream, SHOUT_DOWN_VOLUME)
	set_volume(snakes_stream, SHOUT_DOWN_VOLUME)
	set_volume(tortoise_stream, SHOUT_DOWN_VOLUME)


func tortoise_awake():
	flag_is_awake = true
	gameplay_stream.volume_db = SHOUT_DOWN_VOLUME
	snakes_stream.volume_db = SHOUT_DOWN_VOLUME
	
	tortoise_stream.play()

