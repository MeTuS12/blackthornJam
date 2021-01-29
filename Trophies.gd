extends YSort


var trophies_locked = []
var trophies_unlocked = []

func _ready():
	var save_data = SaveAndLoad.load_data_from_file()

	trophies_locked = get_children()
	trophies_unlocked = save_data[1]

#	if trophies_locked[0].visible == trophies_unlocked.coins:
#		print(trophies_locked)


#	print(trophies_unlocked.keys())

	for t in trophies_locked:
		t.visible = trophies_unlocked[t.ID]
