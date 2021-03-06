extends Control

signal vol_changed
var counter = 0
var config = ConfigFile.new()
var err = config.load("user://wt_settings.cfg")
var easter_egg = ["whale(true)", "whale true", "whale = true", "Whale = true", "SurWhale = true", "SurrailWhale = true"]
onready var mus_slider = $"MarginContainer/Settings/Volume/Music/Music Slider"
onready var sfx_slider = $"MarginContainer/Settings/Volume/Sound/Sound Slider"

func _ready():
	Audio.play(Audio.song_dict.get("dancing_square"), -5, 0, true)
	startup()


func _input(event):
	if event.is_action_pressed("back"):
		if counter >= easter_egg.size():
			$MarginContainer/Main.show()
			$MarginContainer/Label.hide()

func startup():
	if err == OK:
		var mus_vol = config.get_value("volume", "music")
		var sfx_vol = config.get_value("volume", "sound")
		mus_slider.value = mus_vol
		sfx_slider.value = sfx_vol
	else:
		config.set_value("volume", "music", 1)
		config.set_value("volume", "sound", 1)
		config.save("user://wt_settings.cfg")


func _on_Play_pressed():
	Audio.stop_music()
	Audio.play("res://audio/sounds/select1.wav", -10, 0.2)
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_Quit_pressed():
	config.save("user://wt_settings.cfg")
	get_tree().quit()


func _on_Button_pressed():
	Audio.play("res://audio/sounds/select1.wav", -10, 0.2)
	if counter < easter_egg.size():
		$MarginContainer/Main/Button.text = easter_egg[counter]
	if counter >= easter_egg.size():
		$MarginContainer/Main.hide()
		$MarginContainer/Label.show()
	counter += 1


func _on_Volume_pressed():
	Audio.play("res://audio/sounds/select1.wav", -10, 0.2)
	$MarginContainer/Settings.hide()
	$MarginContainer/Volume.show()


func _on_Settings_Back_pressed():
	Audio.play("res://audio/sounds/select1.wav", -10, 0.2)
	$MarginContainer/Settings.hide()
	$MarginContainer/Main.show()


func _on_Settings_pressed():
	Audio.play("res://audio/sounds/select1.wav", -10, 0.2)
	$MarginContainer/Main.hide()
	$MarginContainer/Settings.show()


func _on_Volume_Back_pressed():
	Audio.play("res://audio/sounds/select1.wav", -10, 0.2)
	$MarginContainer/Settings.hide()
	$MarginContainer/Main.show()


func _on_Music_Slider_value_changed(value):
	config.set_value("volume", "music", value)
	config.save("user://wt_settings.cfg")
	emit_signal("vol_changed")


func _on_Sound_Slider_value_changed(value):
	config.set_value("volume", "sound", value)
	config.save("user://wt_settings.cfg")
	emit_signal("vol_changed")


func _on_Editor_pressed():
	Audio.stop_music()
	Audio.play("res://audio/sounds/select1.wav", -10, 0.2)
	get_tree().change_scene("res://scenes/control/Editor.tscn")
