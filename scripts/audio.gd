extends Node

var song_dict = {
	"dancing_cube": "res://audio/music/Dancing Square.wav",
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
	if err != OK:
		config.set_value("volume", "music", 50)
		config.set_value("volume", "sound", 50)
		config.save("user://wt_settings.cfg")
	else:
		mus_vol = config.get_value("volume", "music")
		sfx_vol = config.get_value("volume", "sound")


func _process(delta):
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
		playing_music = audio_player.name
		print("music")
	elif "sounds" in audio:
		audio_player.bus = "Sound"
		print("sound")
	
	add_child(audio_player)
	audio_player.play()
	
	yield(audio_player, "finished")
	if loop:
		play(audio, volume, pitch, loop)
	print("im done with ", audio_player.name)
	if "music" in audio:
		playing_music = ""
	audio_player.queue_free()


func stop_music():
	if playing_music:
		print(playing_music)
		get_node(playing_music).queue_free()
		playing_music = ""
