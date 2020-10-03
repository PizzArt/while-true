extends Node2D

var levels = [preload("res://scenes/Tutorial.tscn").instance(), preload("res://scenes/Level0.tscn").instance(), preload("res://scenes/Level.tscn").instance()]
var levelID = 0
var lastLevel


func _ready():
	lastLevel = add_child( levels[0] )


func next_level():
	levels[levelID].queue_free()
	
	levelID += 1
	var next = levels[levelID]
	add_child(next)
	
