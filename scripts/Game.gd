extends Node2D

var levels = [preload("res://scenes/Tutorial.tscn").instance(),
preload("res://scenes/levels/LevelMoving.tscn").instance(),
preload("res://scenes/levels/Level0.tscn").instance(), 
preload("res://scenes/TutorialMoving.tscn").instance(),

preload("res://scenes/Tutorial2.tscn").instance(),
preload("res://scenes/levels/Level1.tscn").instance(),
preload("res://scenes/levels/Level2.tscn").instance(),
preload("res://scenes/levels/Level3.tscn").instance(),
preload("res://scenes/Ending.tscn").instance(),
]
var levelID = 0
var lastLevel

var transLength = 0.3

func _ready():
	add_child( levels[0] )


func next_level():
	var Trans = $Transition
	get_child(4).pause_mode = Node.PAUSE_MODE_STOP
	get_tree().paused = true
	$Tween.interpolate_property(Trans, "color:a", Trans.color.a, 1, transLength,
	 Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	levels[levelID].queue_free()
	$Tween.interpolate_property(Trans, "color:a", Trans.color.a, 0, transLength,
	 Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
#	yield($Tween, "tween_completed")
	
	levelID += 1
	print(levelID)
	var next = levels[levelID]
	add_child(next)
	
