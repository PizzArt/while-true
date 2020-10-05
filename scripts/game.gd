extends Node2D

var levels = [
preload("res://scenes/text_levels/Tutorial.tscn"), # 0
preload("res://scenes/levels/Level0.tscn"),
preload("res://scenes/text_levels/TutorialMoving.tscn"), # 2
preload("res://scenes/levels/LevelMoving.tscn"),
preload("res://scenes/levels/LevelMoving2.tscn"),
preload("res://scenes/text_levels/TutorialContinue.tscn"),  # 5
preload("res://scenes/levels/LevelContinue0.tscn"),
preload("res://scenes/text_levels/TutorialSpeed.tscn"), # 7
preload("res://scenes/levels/LevelSpeed0.tscn"),
preload("res://scenes/levels/LevelSpeed1.tscn"),
preload("res://scenes/levels/LevelMoving3.tscn"),
preload("res://scenes/levels/LevelMovingLong.tscn"),
preload("res://scenes/text_levels/Ending.tscn") # 9
]

var tutorials = [0,2,5,7]
var tutorials_completed = 0

var levelID = 0
var last_level = -1
var transLength = 0.3


func _physics_process(delta):
	if Input.is_action_just_pressed("tutorial"):
		show_tutorials()
	if Input.is_action_pressed("back"):
		Audio.stop_music()
		get_tree().change_scene("res://scenes/control/Menu.tscn")


func _ready():
	loadLevel(0)


func next_level():
	last_level = levelID
	levelID += 1
	loadLevel(levelID)
	
	print(levelID)


func show_tutorials():
	if tutorials_completed > 0:
		var tut = tutorials[tutorials_completed-1]
		levelID -= 1
		loadLevel(tut);
		tutorials_completed -= 1


func loadLevel(levelID):
	var Trans = $Transition
	if get_child_count() > 4:
		get_child(4).pause_mode = Node.PAUSE_MODE_STOP
		get_tree().paused = true
	$Tween.interpolate_property(Trans, "color:a", Trans.color.a, 1, transLength,
	 Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	if get_child_count() > 4:
		get_child(4).queue_free()
	$Tween.interpolate_property(Trans, "color:a", Trans.color.a, 0, transLength,
	 Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
#	Audio.play("res://audio/sounds/spawn1.wav", -15, 0.15)
	
	var next = levels[levelID]
	add_child(next.instance())
	last_level = levelID
