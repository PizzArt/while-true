extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func play(audio: String, volume = 0, pitch = 0):
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = load(audio)
	audio_player.volume_db = volume
	audio_player.pitch_scale = rng.randfn(1, pitch)
	if "music" in audio:
		audio_player.bus = "Music"
	elif "sounds" in audio:
		audio_player.bus = "Sound"
	
	add_child(audio_player)
	audio_player.play()
	
	yield(audio_player, "finished")
	
	audio_player.queue_free()
