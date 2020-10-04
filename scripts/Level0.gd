extends Node2D

var steps_reset = 5 # RESET STEPS TO
onready var debug = $UI/Debug
var moving_default_position: Array

export var UItopTemplate = 0

func _ready():
	$Player.steps = steps_reset
	
	match UItopTemplate:
		0:
			$UI/Level0.visible = true
			$UI/Level1.visible = false
		1:
			$UI/Level0.visible = false
			$UI/Level1.visible = true
	
	for i in $TileMap.get_used_cells_by_id(7):
		moving_default_position.append(i)


func _physics_process(delta):
	debug()


func reload(funct = "reset()"):
	$Player.fails += 1
	set_color("i5", Color("7bc796"))
	show_func(funct)
	$Player.steps = steps_reset
	cont(false)
	
	var j = 0
	print(moving_default_position.size())
	for k in $TileMap.get_used_cells_by_id(7):    # DELETE ALL MOVING
		$TileMap.set_cell(k.x, k.y, 1)
	for i in moving_default_position.size():
		$TileMap.set_cellv(moving_default_position[j], 7)  #RESET ALL MOVING
		j+=1


func cont(showfunc = true):
	if showfunc:
		show_func("continue;")
	set_color("reset", Color("7bc796"))
	set_color("move", Color.black)
	$Player.position = $Player.default_position
	$Player.current_cell_pos = $Player.default_cell


func step():
	set_color("i5", Color.black)
	set_color("reset", Color.black)
	set_color("move", Color("7bc796"))


func show_func(text):
	get_node("UI/Function/AnimationPlayer").play("fade")
	get_node("UI/Function").text = text


func set_color(node, color):
	get_node("UI/Level1/"+node).get("custom_styles/normal").bg_color = color


func debug():
	debug.text = "  DEBUG\n"
	debug.text += " Global variables\n" + "  speed: " + String($Player.speed)
	debug.text += "\n\n Local variables\n" + "  i: " + String($Player.steps)


func moving():
	for i in $TileMap.get_used_cells_by_id(7):
		if !$TileMap.is_cell_x_flipped(i.x, i.y):
			if $TileMap.get_cell(i.x+1, i.y) == 1:
				$TileMap.set_cell(i.x, i.y, 1)
				$TileMap.set_cell(i.x + 1, i.y, 7)
			else:
				$TileMap.set_cell(i.x, i.y, 1)
				$TileMap.set_cell(i.x - 1, i.y, 7, true)
		else:
			if $TileMap.get_cell(i.x - 1, i.y) == 1:
				$TileMap.set_cell(i.x, i.y, 1)
				$TileMap.set_cell(i.x - 1, i.y, 7, true)
			else:
				$TileMap.set_cell(i.x, i.y, 1)
				$TileMap.set_cell(i.x + 1, i.y, 7, false)
