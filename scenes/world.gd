extends Node2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var grid: TileMapLayer = $GRID
@export var CELL_SIZE = 32;
@export var board = []
const CELL = preload("res://cell.tscn")

func _ready() -> void:
	var size = get_viewport_rect().size
	var x_range: int = floor(size.x / CELL_SIZE)
	var y_range: int = floor(size.y / CELL_SIZE)
	for x in x_range:
		var row = []
		for y in y_range:
			var cell = CELL.instantiate()
			cell.board_position = Vector2(x, y)
			cell.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
			cell.size = CELL_SIZE
			row.append(cell)
			add_child(cell)
			cell.update()
			
		board.append(row)
