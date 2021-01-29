extends YSort


var trophies = []
var i = 0

func _ready():
	trophies = get_children()
	

func _physics_process(delta):
		for t in trophies:
			if i < 8:
				trophies[i].visible = false
				i += 1
