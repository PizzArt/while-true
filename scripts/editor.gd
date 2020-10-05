extends Control

signal save_path_changed
signal load_path_changed
var bounds = Vector2(-10, 9)
var current_tile = 1
var start_placed = false
var start_pos = Vector2()
var draw = false
var in_menu = true
var level_save_path = ""
var level_load_path = ""
var level = preload("res://scenes/Example.tscn")
var player = preload("res://scenes/Player.tscn")
onready var buttons = [
	$"CL/UI/1/2/3/Tiles/BG",
	$"CL/UI/1/2/3/Tiles/Start",
	$"CL/UI/1/2/3/Tiles/Wall",
	$"CL/UI/1/2/3/Tiles/Continue",
	$"CL/UI/1/2/3/Tiles/Break",
	$"CL/UI/1/2/3/Tiles/I",
	$"CL/UI/1/2/3/Tiles/Move",
	$"CL/UI/1/2/3/Tiles/Speed2",
	$"CL/UI/1/2/3/Tiles/Speed1"
]
onready var tilemap = $TileMap


func _ready():
	get_node("CL/UI/1").visible = false
	get_node("CL/UI/Menu").visible = true
	$CL/UI.mouse_filter = MOUSE_FILTER_IGNORE


func _process(_delta):
	if draw and not in_menu:
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tilemap.map_to_world(tilemap.world_to_map(mouse_pos)) / 16
		if Input.is_action_pressed("set") and tile_pos.x >= bounds.x and tile_pos.x <= bounds.y and tile_pos.y >= bounds.x and tile_pos.y <= bounds.y:
			if current_tile == 8:
				if !start_placed:
					tilemap.set_cellv(tile_pos, current_tile)
					start_pos = tile_pos
					start_placed = true
			else:
				if start_placed:
					if !tile_pos == start_pos:
						tilemap.set_cellv(tile_pos, current_tile)
				else:
					tilemap.set_cellv(tile_pos, current_tile)
		if Input.is_action_pressed("delete"):
			tilemap.set_cellv(tile_pos, -1)
			if tile_pos == start_pos:
				start_placed = false


func toggle(button, tile):
	button.pressed = true
	button.grab_focus()
	for btn in buttons:
		if btn != button:
			btn.pressed = false
	current_tile = tile


func save_level():
	var packed_scene = PackedScene.new()
	packed_scene.pack(tilemap)
	yield(self, "save_path_changed")
	ResourceSaver.save(level_save_path, packed_scene)


func autosave():
	var packed_scene = PackedScene.new()
	packed_scene.pack(tilemap)
	ResourceSaver.save("user://autosave.tscn", packed_scene)


func load_level():
	tilemap.queue_free()
	var packed_scene = load(level_load_path)
	var map = packed_scene.instance()
	add_child(map)
	tilemap = map


func test_level():
	autosave()
	var spawn = $TileMap.get_used_cells_by_id(8)[0]
	print("spawn: ", spawn)
	$TileMap.position.x -= 8
	$TileMap.position.y -= 8
	var character = player.instance()
	character.in_editor = true
	var lvl = level.instance()
	remove_child(tilemap)
	lvl.add_child(tilemap)
	character.position = start_pos * 16
	lvl.add_child(character)
	print(character.position, start_pos)
	add_child(lvl)
	$CL/UI/Menu.hide()
	$CL/UI/Finish.show()


func finish_test():
	var children = get_children()
	for i in children:
		if i.name == "Level":
			i.queue_free()
	var packed_scene = load("user://autosave.tscn")
	var map = packed_scene.instance()
	add_child(map)
	tilemap = map
	$"CL/UI/1".show()
	$CL/UI/Finish.hide()
	draw = true
	in_menu = false


func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		$"CL/UI/1/2/HideButton".hide()
		$"CL/UI/1/2/Text".hide()


func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_1) and just_pressed:
		_on_BG_pressed()
	if Input.is_key_pressed(KEY_2) and just_pressed:
		_on_Start_pressed()
	if Input.is_key_pressed(KEY_3) and just_pressed:
		_on_Wall_pressed()
	if Input.is_key_pressed(KEY_4) and just_pressed:
		_on_Continue_pressed()
	if Input.is_key_pressed(KEY_5) and just_pressed:
		_on_Break_pressed()
	if Input.is_key_pressed(KEY_6) and just_pressed:
		_on_I_pressed()
	if Input.is_key_pressed(KEY_7) and just_pressed:
		_on_Move_pressed()
	if Input.is_key_pressed(KEY_8) and just_pressed:
		_on_Speed2_pressed()
	if Input.is_key_pressed(KEY_9) and just_pressed:
		_on_Speed1_pressed()


func _on_BG_pressed():
	toggle(buttons[0], 1)


func _on_Start_pressed():
	toggle(buttons[1], 8)


func _on_Wall_pressed():
	toggle(buttons[2], 0)


func _on_Continue_pressed():
	toggle(buttons[3], 6)


func _on_Break_pressed():
	toggle(buttons[4], 5)


func _on_I_pressed():
	toggle(buttons[5], 4)


func _on_Move_pressed():
	toggle(buttons[6], 7)


func _on_Speed2_pressed():
	toggle(buttons[7], 2)


func _on_Speed1_pressed():
	toggle(buttons[8], 3)


func _on_Menu_Button_pressed():
	$CL/UI/Menu.show()
	$"CL/UI/1".hide()
	draw = false
	in_menu = true


func _on_Return_pressed():
	$CL/UI/Menu.hide()
	$"CL/UI/1".show()
	draw = true
	in_menu = false


func _on_Save_pressed():
	$"CL/UI/Menu/Dialogs/Save Dialog".popup()


func _on_Save_Dialog_file_selected(path):
	level_save_path = path
	emit_signal("save_path_changed")


func _on_Save_Dialog_confirmed():
	save_level()


func _on_Main_Menu_pressed():
	$CL/UI/Menu/Dialogs/Quit.popup()


func _on_Quit_confirmed():
	get_tree().change_scene("res://scenes/control/Menu.tscn")


func _on_Test_pressed():
	if $TileMap.get_used_cells_by_id(8).size():
		test_level()
	else:
		$CL/UI/Menu/Dialogs/Start.popup()


func _on_Finish_pressed():
	finish_test()


func _on_Load_pressed():
	$"CL/UI/Menu/Dialogs/Load Dialog".popup()


func _on_Load_Dialog_file_selected(path):
	level_load_path = path
	emit_signal("load_path_changed")


func _on_Load_Dialog_confirmed():
	$CL/UI/Menu/Dialogs/Overwrite.popup()


func _on_Overwrite_confirmed():
	load_level()


func _on_Area2D_mouse_entered():
	draw = false


func _on_HideButton_mouse_entered():
	draw = false
func _on_HideButton_mouse_exited():
	draw = true


