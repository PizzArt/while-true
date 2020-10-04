extends Control

signal path_changed
var current_tile = 0
var start_placed = false
var start_pos = Vector2()
var draw = true
var level_save_path = ""
var level = preload("res://scenes/Example.tscn")
var player = preload("res://scenes/Player.tscn")
onready var buttons = [$"CL/UI/1/2/3/Tiles/BG",
	$"CL/UI/1/2/3/Tiles/Start",
	$"CL/UI/1/2/3/Tiles/Wall",
	$"CL/UI/1/2/3/Tiles/Continue",
	$"CL/UI/1/2/3/Tiles/Break",
	$"CL/UI/1/2/3/Tiles/I",
	$"CL/UI/1/2/3/Tiles/Move"]
onready var tilemap = $Level


func _process(_delta):
	if draw:
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tilemap.map_to_world(tilemap.world_to_map(mouse_pos)) / 16
		if Input.is_action_pressed("set"):
			if current_tile == 1:
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
	for btn in buttons:
		if btn != button:
			btn.pressed = false
	current_tile = tile


func save_level():
	var packed_scene = PackedScene.new()
	packed_scene.pack($Level)
	yield(self, "path_changed")
	ResourceSaver.save(level_save_path, packed_scene)


func test_level():
	var character = player.instance()
	add_child(character)
	var lvl = level.instance()
	add_child(lvl)


func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		$"CL/UI/1/2/HideButton".hide()
		$"CL/UI/1/2/Text".hide()


func _on_BG_pressed():
	toggle(buttons[0], 0)


func _on_Start_pressed():
	toggle(buttons[1], 1)


func _on_Wall_pressed():
	toggle(buttons[2], 2)


func _on_Continue_pressed():
	toggle(buttons[3], 5)


func _on_Break_pressed():
	toggle(buttons[4], 4)


func _on_I_pressed():
	toggle(buttons[5], 3)


func _on_Move_pressed():
	toggle(buttons[6], 6)


func _on_Menu_Button_pressed():
	$CL/UI/Menu.show()
	$"CL/UI/1".hide()
	draw = false


func _on_Return_pressed():
	$CL/UI/Menu.hide()
	$"CL/UI/1".show()
	draw = true


func _on_Save_pressed():
	$"CL/UI/Menu/Dialogs/Save Dialog".popup()


func _on_Save_Dialog_file_selected(path):
	level_save_path = path
	level_save_path = path
	emit_signal("path_changed")


func _on_Save_Dialog_confirmed():
	save_level()


func _on_Main_Menu_pressed():
	$CL/UI/Menu/Dialogs/Quit.popup()


func _on_Quit_confirmed():
	get_tree().change_scene("res://scenes/Menu.tscn")
