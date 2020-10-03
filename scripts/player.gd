extends Sprite


enum {WALL, BG, SPD2, SPD1, I5, SMTH, RELOAD}

var can_move = true
var current_cell_pos = Vector2()
var current_cell
var movement = Vector2()

var steps = 1
var speed = 1

onready var tilemap = get_parent().get_node("TileMap")
onready var debug = get_parent().get_node("Control/Debug")


func _ready():
	debug()


func _process(delta):
	move()


func move():
	if can_move and (Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right")
			   or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down")):
		var direction = Vector2()
		if Input.is_action_just_pressed("left"):
			if tilemap.get_cell(current_cell_pos.x - speed, current_cell_pos.y) != WALL:
				direction.x = -speed
				current_cell_pos.x -= speed
		elif Input.is_action_just_pressed("right"):
			if tilemap.get_cell(current_cell_pos.x + speed, current_cell_pos.y) != WALL:
				direction.x = speed
				current_cell_pos.x += speed
		elif Input.is_action_just_pressed("up"):
			if tilemap.get_cell(current_cell_pos.x, current_cell_pos.y - speed) != WALL:
				direction.y = -speed
				current_cell_pos.y -= speed
		elif Input.is_action_just_pressed("down"):
			if tilemap.get_cell(current_cell_pos.x, current_cell_pos.y + speed) != WALL:
				direction.y = speed
				current_cell_pos.y += speed
		movement = direction * 16
		position += movement
		
		current_cell = tilemap.get_cellv(current_cell_pos)
		can_move = false
		check_cell()
		next_step()


func check_cell():
	match current_cell:
		WALL:
			get_parent().reload()
		SPD1:
			speed = 1
		SPD2:
			speed = 2
		I5:
			steps = 10
		RELOAD:
			get_parent().cont()


func next_step():
	$StepCooldown.start()
	steps -= 1
	if steps <= 0:
		get_parent().reload()
	debug()


func debug():
	print(current_cell_pos , " " , tilemap.get_cell(current_cell_pos.x, current_cell_pos.y));
	debug.text = ""
	debug.text += "Global\n" + "  speed: " + String(speed)
	debug.text += "\nLocal\n" + "  steps: " + String(steps)


func _on_StepCooldown_timeout():
	can_move = true
