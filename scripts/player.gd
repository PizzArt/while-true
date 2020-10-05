extends Sprite


enum {WALL, BG, SPD2, SPD1, I5, FINISH, RELOAD, MOVING}

var can_move = true
var current_cell_pos = Vector2()
var current_cell
var movement = Vector2()
var default_position
var default_cell

var in_editor = false
var steps = 1
var speed = 1

onready var tilemap = get_parent().get_node("TileMap")


func _ready():
	default_position = position
	current_cell_pos = Vector2(int(position.x/16), int(position.y/16) )
	default_cell = current_cell_pos
	print("default cell: ", default_cell)


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
		Audio.play("res://audio/sounds/step1.wav", -20)
		get_parent().moving()
		current_cell = tilemap.get_cellv(current_cell_pos)
		can_move = false
		next_step()


func check_cell():
	match current_cell:
		WALL:
			get_parent().reload("die()")
		SPD1:
			speed = 1
			Audio.play("res://audio/sounds/speed1.wav", 0, 0.15)
		SPD2:
			speed = 2
			Audio.play("res://audio/sounds/speed2.wav", 0, 0.15)
		I5:
			steps = 10
			Audio.play("res://audio/sounds/stepincrease2.wav", -20, 0.3)
		RELOAD:
			get_parent().cont()
			Audio.play("res://audio/sounds/reset1.wav", 0, 0.15)
		FINISH:
			if !in_editor:
				get_parent().get_parent().next_level()
				can_move = false
				$StepCooldown.stop()
				Audio.play("res://audio/sounds/complete1.wav", -10, 0.15)
			else:
				get_parent().reload()
		MOVING:
			can_move = false
			$ReloadDelay.start()
			$AnimationPlayer.play("reload")
			Audio.play("res://audio/sounds/death1.wav", -9, 0.2)
			return 1


func next_step():
	steps -= 1
	var moving = check_cell() 
	get_parent().step()
	if steps <= 0:
		can_move = false
		$ReloadDelay.start()
		$AnimationPlayer.play("reload")
	elif not moving:
		$StepCooldown.start()


func _on_StepCooldown_timeout():
	can_move = true


func _on_ReloadDelay_timeout():
	can_move = true
	get_parent().reload()
