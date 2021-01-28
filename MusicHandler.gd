extends Node



const NORMAL_VOLUME = -5.0
const SNAKE_VOLUME = -2.0
const SHOUT_DOWN_VOLUME = -80.0


onready var gameplay_stream = $GameplayStream 
onready var snakes_stream = $SnakesStream
onready var tortoise_stream = $TortoiseStream

onready var tween = $Tween

var flag_is_awake = false

var n_snakes = 0
var snakes = []


func set_volume(stream, volume):
	tween.interpolate_property(stream, "volume_db", stream.volume_db, volume, 1.0,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()


func _ready():
	gameplay_stream.volume_db = NORMAL_VOLUME
	snakes_stream.stop()


func snake_pursuing(snake):
	if not flag_is_awake:
		if not snakes.has(snake):
			snakes.append(snake)
		
		if snakes_stream.volume_db == SHOUT_DOWN_VOLUME:
			set_volume(snakes_stream, SNAKE_VOLUME)



func snake_stop(snake):
	var i = snakes.find(snake)
	
	if i > -1:
		snakes.remove(i)
	
	if snakes.size() == 0:
		set_volume(snakes_stream, SHOUT_DOWN_VOLUME)


func tortoise_in_range():
	gameplay_stream.stop()
#	set_volume(gameplay_stream, SHOUT_DOWN_VOLUME)


func tortoise_out_of_range():
	gameplay_stream.play()
#	set_volume(gameplay_stream, NORMAL_VOLUME)


func tortoise_awake():
	print('AWAKE????? MUSIC???')
	flag_is_awake = true
	gameplay_stream.volume_db = SHOUT_DOWN_VOLUME
	snakes_stream.volume_db = SHOUT_DOWN_VOLUME
	
	tortoise_stream.play()

