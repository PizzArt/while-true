extends Node2D

var steps_reset = 5 # RESET STEPS TO
onready var debug = $Control/Debug

func _ready():
	$Player.steps = steps_reset


func reload():
	set_color("i5", Color("7bc796"))
	show_func("reset();")
	$Player.steps = steps_reset
	debug()
	cont()


func cont():
	show_func("continue;")
	set_color("reset", Color("7bc796"))
	set_color("move", Color.black)
	$Player.position = Vector2(8,8)
	$Player.current_cell_pos = Vector2(0,0)


func step():
	debug()
	set_color("i5", Color.black)
	set_color("reset", Color.black)
	set_color("move", Color("7bc796"))


func show_func(text):
	get_node("Control/Function/AnimationPlayer").play("fade")
	get_node("Control/Function").text = text


func set_color(node, color):
	get_node("UI/Level1/"+node).get("custom_styles/normal").bg_color = color


func debug():
	debug.text = ""
	debug.text += "Global\n" + "  speed: " + String($Player.speed)
	debug.text += "\nLocal\n" + "  steps: " + String($Player.steps)
