extends Node2D

func _process(delta):
	if Input.is_action_pressed("accept"):
		get_parent().next_level()
		get_parent().tutorials_completed += 1
