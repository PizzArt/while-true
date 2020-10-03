extends Node2D

var levels = [preload("res://scenes/Tutorial.tscn").instance(),
preload("res://scenes/levels/Level0.tscn").instance(), 
preload("res://scenes/Tutorial2.tscn").instance(),
preload("res://scenes/levels/LevelMoving.tscn").instance(),
preload("res://scenes/levels/Level1.tscn").instance(),
preload("res://scenes/levels/Level2.tscn").instance(),
preload("res://scenes/levels/Level3.tscn").instance(),
preload("res://scenes/Ending.tscn").instance(),
]
var levelID = 0
var lastLevel


func _ready():
	add_child( levels[0] )


func next_level():
	levels[levelID].queue_free()
	
	levelID += 1
	print(levelID)
	var next = levels[levelID]
	add_child(next)
	
