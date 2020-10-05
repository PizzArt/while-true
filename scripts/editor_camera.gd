extends Camera2D

var last_mouse_pos = get_global_mouse_position()
var mouse_pos = last_mouse_pos
var dragging = false
var reset = false
var target_zoom: Vector2
var zoom_speed = Vector2(0.05, 0.05)

func _ready():
	zoom = Vector2(1, 1)
	target_zoom = zoom


func _process(delta):
	var mous_pos = get_local_mouse_position()
	if mous_pos.y < -300 * zoom.x or mous_pos.y > 300 * zoom.x or mous_pos.x < -310 * zoom.x or mous_pos.x > 800:
		get_parent().draw = false
	else:
		get_parent().draw = true
		
	zoom()
	if dragging:
		if reset:
			reset = false
			mouse_pos = get_global_mouse_position()
			last_mouse_pos = mouse_pos
		mouse_pos = get_global_mouse_position()
		var diff = (last_mouse_pos - mouse_pos)
		translate(diff)
		last_mouse_pos = mouse_pos
	else:
		reset = true


func _input(event):     
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		if not dragging:
			dragging = true
		else:
			dragging = false
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				target_zoom -= zoom_speed
			if event.button_index == BUTTON_WHEEL_DOWN:
				target_zoom += zoom_speed
			target_zoom.x = clamp(target_zoom.x, 0.3, 5)
			target_zoom.y = target_zoom.x


func zoom():
	self.zoom = self.zoom.linear_interpolate(target_zoom, 0.2)

