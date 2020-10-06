extends Node

var song_dict = {
	"dancing_square": "res://audio/music/Dancing Square.wav",
	"song1": "res://audio/music/ld47_1.wav"
}
var playing_music = ""
var config = ConfigFile.new()
var err = config.load("user://wt_settings.cfg")
var mus_vol
var sfx_vol
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	get_parent().get_node("Menu").connect("vol_changed", self, "_on_vol_changed")
	if err != OK:
		config.set_value("volume", "music", 1)
		config.set_value("volume", "sound", 1)
		config.save("user://wt_settings.cfg")
		mus_vol = linear2db(config.get_value("volume", "music"))
		sfx_vol = linear2db(config.get_value("volume", "sound"))
		AudioServer.set_bus_volume_db(1, mus_vol)
		AudioServer.set_bus_volume_db(2, sfx_vol)
	else:
		mus_vol = config.get_value("volume", "music")
		sfx_vol = config.get_value("volume", "sound")
		AudioServer.set_bus_volume_db(1, mus_vol)
		AudioServer.set_bus_volume_db(2, sfx_vol)


func _on_vol_changed():
	config = ConfigFile.new()
	err = config.load("user://wt_settings.cfg")
	mus_vol = linear2db(config.get_value("volume", "music"))
	sfx_vol = linear2db(config.get_value("volume", "sound"))
	AudioServer.set_bus_volume_db(1, mus_vol)
	AudioServer.set_bus_volume_db(2, sfx_vol)


func play(audio: String, volume = 0, pitch = 0, loop = false):
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = load(audio)
	audio_player.name = audio.split("/")[-1].split(".")[0]
	audio_player.volume_db = volume
	audio_player.pitch_scale = rng.randfn(1, pitch)
	if "music" in audio:
		audio_player.bus = "Music"
	elif "sounds" in audio:
		audio_player.bus = "Sound"
	
	add_child(audio_player)
	if "music" in audio:
		if playing_music:
			get_node(playing_music).queue_free()
		playing_music = audio_player.name
	audio_player.play()
	
	yield(audio_player, "finished")
	if loop:
		play(audio, volume, pitch, loop)
	if "music" in audio:
		playing_music = ""
	audio_player.queue_free()


func stop_music():
	if playing_music:
		get_node(playing_music).queue_free()
		playing_music = ""
