class_name Field
extends ColorRect

const GRID_WIDTH = 6
const GRID_HEIGHT = 6

var cell_size: Vector2
var hovered_cell := Vector2i(-1, -1)

signal cell_clicked(cell: Vector2i)
signal cell_hovered(cell: Vector2i)

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	update_grid()
	mouse_exited.connect(_on_mouse_exit)

func _on_mouse_exit():
	hovered_cell = Vector2i(-1,-1)
	queue_redraw()

func update_grid():
	cell_size = size / Vector2(GRID_WIDTH, GRID_HEIGHT)
	queue_redraw()


func get_cell_at_position(pos: Vector2) -> Vector2i:
	var x = int(pos.x / cell_size.x)
	var y = int(pos.y / cell_size.y)

	return Vector2i(x, y)


func is_valid_cell(cell: Vector2i) -> bool:
	return (
		cell.x >= 0 and cell.x < GRID_WIDTH
		and cell.y >= 0 and cell.y < GRID_HEIGHT
	)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var cell = get_cell_at_position(event.position)

			if is_valid_cell(cell):
				cell_clicked.emit(cell)


	if event is InputEventMouseMotion:
		var cell = get_cell_at_position(event.position)

		if is_valid_cell(cell):
			if cell != hovered_cell:
				hovered_cell = cell
				cell_hovered.emit(cell)
				queue_redraw()
		else:
			hovered_cell = Vector2i(-1, -1)
			queue_redraw()


func _draw():
	# Grid
	for x in range(GRID_WIDTH + 1):
		draw_line(
			Vector2(x * cell_size.x, 0),
			Vector2(x * cell_size.x, size.y),
			Color.BLACK, 5
		)

	for y in range(GRID_HEIGHT + 1):
		draw_line(
			Vector2(0, y * cell_size.y),
			Vector2(size.x, y * cell_size.y),
			Color.BLACK, 5
		)

	# Hover highlight
	if is_valid_cell(hovered_cell):
		var rect = Rect2(
			hovered_cell.x * cell_size.x,
			hovered_cell.y * cell_size.y,
			cell_size.x,
			cell_size.y
		)

		draw_rect(rect, Color(1, 1, 1, 0.3), true)


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		update_grid()
