extends Node2D

var steps_reset = 5 # RESET STEPS TO
onready var debug = $UI/Debug

func _ready():
	$Player.steps = steps_reset


func reload():
	set_color("i5", Color("7bc796"))
	show_func("reset();")
	$Player.steps = steps_reset
	debug()
	cont(false)


func cont(showfunc = true):
	if showfunc:
		show_func("continue;")
	set_color("reset", Color("7bc796"))
	set_color("move", Color.black)
	$Player.position = $Player.default_position
	$Player.current_cell_pos = $Player.default_cell


func step():
	debug()
	set_color("i5", Color.black)
	set_color("reset", Color.black)
	set_color("move", Color("7bc796"))


func show_func(text):
	get_node("UI/Function/AnimationPlayer").play("fade")
	get_node("UI/Function").text = text


func set_color(node, color):
	get_node("UI/Level1/"+node).get("custom_styles/normal").bg_color = color


func debug():
	debug.text = "  DEBUG"
	debug.text += "Global variables\n" + "  speed: " + String($Player.speed)
	debug.text += "\nLocal variables\n" + "  steps: " + String($Player.steps)
