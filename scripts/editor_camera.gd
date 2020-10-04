extends Camera2D

var last_mouse_pos = get_global_mouse_position()
var mouse_pos = last_mouse_pos
var dragging = false

func _process(delta):
	if dragging:
		mouse_pos = get_global_mouse_position()
		var diff = (last_mouse_pos - mouse_pos).normalized() * 20
		translate(diff)
		last_mouse_pos = mouse_pos

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		if not dragging:
			dragging = true
		else:
			dragging = false
