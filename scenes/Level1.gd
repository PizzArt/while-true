extends Node2D


var steps_reset = 5 # RESET STEPS TO


func _ready():
	$Player.steps = steps_reset



func reload():
	show_func("reset();")
	$Player.steps = steps_reset
	$Player.debug()
	cont()


func cont():
	$Player.position = Vector2(8,8)
	$Player.current_cell_pos = Vector2(0,0)


func show_func(text):
	get_node("Control/Function/AnimationPlayer").play("fade")
	get_node("Control/Function").text = text
