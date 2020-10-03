extends Sprite


enum {WALL, BG, SPD2, SPD1, I5, FINISH, RELOAD, MOVING}

var can_move = true
var current_cell_pos = Vector2()
var current_cell
var movement = Vector2()
var default_position
var default_cell

var steps = 1
var speed = 1

onready var tilemap = get_parent().get_node("TileMap")


func _ready():
	default_position = position
	current_cell_pos = Vector2(int(position.x/16), int(position.y/16) )
	default_cell = current_cell_pos


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
		
		get_parent().moving()
		current_cell = tilemap.get_cellv(current_cell_pos)
		can_move = false
		print("next step")
		next_step()


func check_cell():
	match current_cell:
		WALL:
			get_parent().reload("die()")
		SPD1:
			speed = 1
		SPD2:
			speed = 2
		I5:
			steps = 10
		RELOAD:
			get_parent().cont()
		FINISH:
			get_parent().get_parent().next_level()
			can_move = false
			$StepCooldown.stop()
		MOVING:
			get_parent().reload("die()")


func next_step():
	steps -= 1
	check_cell()
	get_parent().step()
	if steps <= 0:
		can_move = false
		$ReloadDelay.start()
		$AnimationPlayer.play("reload")
	else:
		$StepCooldown.start()


func _on_StepCooldown_timeout():
	can_move = true


func _on_ReloadDelay_timeout():
	can_move = true
	get_parent().reload()
