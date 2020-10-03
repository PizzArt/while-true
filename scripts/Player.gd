extends Sprite

enum {WALL, BG, SPD2, SPD1, I5}

var canMove:bool = true
var currentCellPos = Vector2(0,0)
var currentCell
var steps = 10
var speed = 1

onready var tilemap = get_parent().get_node("TileMap")
onready var debug = get_parent().get_node("Debug")


func _ready():
	Debug()


func _physics_process(delta):
	move()
	
	


func move():
	if canMove and (Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right")
			   or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down")):
		if Input.is_action_just_pressed("left"):
			if tilemap.get_cell(currentCellPos.x - speed, currentCellPos.y) != WALL:
				position.x -= 16 * speed
				currentCellPos.x -= speed
		elif Input.is_action_just_pressed("right"):
			if tilemap.get_cell(currentCellPos.x + speed, currentCellPos.y) != WALL:
				position.x += 16 * speed
				currentCellPos.x += speed
		elif Input.is_action_just_pressed("up"):
			if tilemap.get_cell(currentCellPos.x, currentCellPos.y - speed) != WALL:
				position.y -= 16 * speed
				currentCellPos.y -= speed
		else:
			if tilemap.get_cell(currentCellPos.x, currentCellPos.y + speed) != WALL:
				position.y += 16 * speed
				currentCellPos.y += speed
		
		currentCell = tilemap.get_cellv(currentCellPos)
		canMove = false
		checkCell()
		nextStep()




func checkCell():
	match currentCell:
		WALL:
			reload()
		BG:
			pass
		SPD2:
			speed = 2
		SPD1:
			speed = 1
		I5:
			steps += 5
	


func nextStep():
	$StepCooldown.start()
	steps -= 1
	if steps <= 0:
		reload()
	
	Debug()


func reload():
	steps = 10
	position = Vector2(8,8)
	currentCellPos = Vector2(0,0)


func Debug():
	print(currentCellPos , " " , tilemap.get_cell(currentCellPos.x, currentCellPos.y));
	debug.text = ""
	debug.text += "Global\n" + "  speed: " + String(speed)
	debug.text += "\nLocal\n" + "  steps: " + String(steps)


func _on_StepCooldown_timeout():
	canMove = true
