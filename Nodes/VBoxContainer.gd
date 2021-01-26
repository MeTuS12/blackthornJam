extends VBoxContainer

var buttons = Array()
var i = 0
var menu = null

func _ready():
	buttons = get_children()
#	buttons.sort_custom(self, "buttons_sort")
	buttons[0].grab_focus()
	menu = get_parent().get_parent().get_parent().get_parent()
	print(buttons)


func buttons_sort(a, b):
	if a.rect_position.y != b.rect_position.y:
		return a.rect_position.y < b.rect_position.y
	return a.rect_position.x < b.rect_position.x

func _physics_process(delta):
	if menu.visible:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left"):
			i -= 1
			if i < 0:
				i = buttons.size() - 1
			buttons[i].grab_focus()
		elif Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right"):
			i += 1
			if i >= buttons.size():
				i = 0
			buttons[i].grab_focus()
		print(i)
