extends Control

var counter = 0
var config = ConfigFile.new()
var err = config.load("user://wt_settings.cfg")
onready var mus_slider = $"MarginContainer/Volume/Volume/Music/Music Slider"
onready var sfx_slider = $"MarginContainer/Volume/Volume/Sound/Sound Slider"

func _ready():
	startup()


func startup():
	if err == OK:
		var mus_vol = config.get_value("volume", "music")
		var sfx_vol = config.get_value("volume", "sound")
		mus_slider.value = mus_vol
		sfx_slider.value = sfx_vol
	else:
		config.set_value("volume", "music", 50)
		config.set_value("volume", "sound", 50)
		config.save("user://wt_settings.cfg")


func _on_Play_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Button_pressed():
	counter += 1
	if counter >= 1:
		$MarginContainer/Main/Button.text = "while(clicks <= 10)"
	if counter >= 10:
		$MarginContainer/Main.hide()
		$MarginContainer/Label.show()


func _on_Volume_pressed():
	$MarginContainer/Settings.hide()
	$MarginContainer/Volume.show()


func _on_Settings_Back_pressed():
	$MarginContainer/Settings.hide()
	$MarginContainer/Main.show()


func _on_Settings_pressed():
	$MarginContainer/Main.hide()
	$MarginContainer/Settings.show()


func _on_Volume_Back_pressed():
	$MarginContainer/Volume.hide()
	$MarginContainer/Settings.show()


func _on_Music_Slider_value_changed(value):
	config.set_value("volume", "music", value)
	config.save("user://wt_settings.cfg")


func _on_Sound_Slider_value_changed(value):
	config.set_value("volume", "sound", value)
	config.save("user://wt_settings.cfg")


func _on_Editor_pressed():
	get_tree().change_scene("res://scenes/Editor.tscn")
