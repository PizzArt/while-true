extends TileMap

onready var grid = self
var grid_width = 20
onready var offset = grid_width * 8


func _draw():
	var LINE_COLOR = Color(1, 1, 1, 0.2)
	var LINE_WIDTH = 2
	var window_size = OS.get_window_size()

	for x in range(grid_width + 1):
		var col_pos = x * cell_size.x - offset
		var limit = grid_width * cell_size.x
		draw_line(Vector2(col_pos, - offset), Vector2(col_pos, limit - offset), LINE_COLOR, LINE_WIDTH)
	for y in range(grid_width + 1):
		var row_pos = y * cell_size.y - offset
		var limit = grid_width * cell_size.x
		draw_line(Vector2( - offset, row_pos), Vector2(limit - offset, row_pos), LINE_COLOR, LINE_WIDTH)
