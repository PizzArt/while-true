extends Node2D


func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("accept"):
		get_parent().next_level()
