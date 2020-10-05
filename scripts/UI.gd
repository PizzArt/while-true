extends CanvasLayer

onready var debug = get_node("Debug")

func show_bottom_text(text):
	$BottomText.text = text
	$Tween.interpolate_property($BottomText, "modulate:a", 1, 0, 5, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
