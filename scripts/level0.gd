extends Node2D

var steps_reset = 5
onready var debug = $UI/Debug
var moving_default_position: Array
var moving_default_rotation: Array

export(String, "dancing_square", "song1") var song = "song1"
export var UItopTemplate = 0

func _ready():
	Audio.play( Audio.song_dict.get(song), 0, 0, true )
	if name == "LevelMoving":
		$UI.show_bottom_text("You can look at previous tutorials by pressing 'T' ")
	if get_parent() is Viewport:
		add_camera()
	$UI.get_node("Debug").visible = true
	$UI.get_node("Function").visible = true
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
		moving_default_rotation.append( $TileMap.is_cell_x_flipped(i.x, i.y) )


func _physics_process(delta):
	debug()


func add_camera():
	var camera = Camera2D.new()
	camera.zoom = Vector2(0.3,0.3)
	camera.current = true
	camera.position += Vector2(153.6, 72)
	add_child(camera)


func reload(funct = "reset()"):
	set_color("i5", Color("7bc796"))
	show_func(funct)
	$Player.steps = steps_reset
	$Player.speed = 1
	cont(false)
	
	var j = 0
	for k in $TileMap.get_used_cells_by_id(7):    # DELETE ALL MOVING
		$TileMap.set_cell(k.x, k.y, 1)
	for i in moving_default_position.size():
		$TileMap.set_cellv(moving_default_position[j], 7, moving_default_rotation[j])  # RESET ALL MOVING
		
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
#	debug.text += " Global variables\n" + "  speed: " + String($Player.speed)
	debug.text += "\n Local variables\n" + "  i: " + String($Player.steps)
	debug.text += "\n  speed: " + String($Player.speed)


func moving():
	for i in $TileMap.get_used_cells_by_id(7):
		if !$TileMap.is_cell_x_flipped(i.x, i.y):
			$TileMap.set_cell(i.x, i.y, 1)
			if $TileMap.get_cell(i.x+1, i.y) == 1:
				$TileMap.set_cell(i.x + 1, i.y, 7)
			else:
				$TileMap.set_cell(i.x - 1, i.y, 7, true)
		else:
			$TileMap.set_cell(i.x, i.y, 1)
			if $TileMap.get_cell(i.x - 1, i.y) == 1:
				$TileMap.set_cell(i.x - 1, i.y, 7, true)
			else:
				$TileMap.set_cell(i.x + 1, i.y, 7, false)

