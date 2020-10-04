extends Camera2D


func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("down"):
		position.y += 0.5
