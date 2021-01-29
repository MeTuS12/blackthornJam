extends YSort


var trophies_locked = []
var trophies_unlocked = []
var i = 0

func _ready():
	var save_data = SaveAndLoad.load_data_from_file()
	
	trophies_locked = get_children()
	trophies_unlocked = save_data[1]
	
	if trophies_locked[0].visible == trophies_unlocked.coins:
		print(trophies_locked)
		
	
	print(trophies_unlocked.keys())
	
	while i < trophies_locked.size():
		for t in trophies_locked:
			if trophies_locked[i].ID == trophies_unlocked.keys()[i]:
				trophies_locked[i].visible = trophies_unlocked.values()[i]
				i += 1
