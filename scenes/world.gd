extends Node2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var grid: TileMapLayer = $GRID

class Cell:
	var from_home = INF
	var from_food = INF
	var pos: Vector2 = Vector2.ZERO
	var node: Node2D;

const CELLL = preload("res://celll.tscn")
@export var board = []
const CELL_SIZE = 32;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var size = get_viewport_rect().size
	var x_range: int = floor(size.x / CELL_SIZE)
	var y_range: int = floor(size.y / CELL_SIZE)
	for x in x_range:
		var row = []
		for y in y_range:
			var cell = Cell.new()
			var sprite = CELLL.instantiate()
			sprite.global_position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
			cell.pos = Vector2(x, y)
			add_child(sprite)
			row.append(cell)
			cell.node = sprite
			
		board.append(row)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for row in board:
		for cell in row:
			if cell.from_home == INF:
				cell.node.modulate.a = 0.0
			else:
				cell.node.modulate = Color(500 / (2 + cell.from_home), 40, 500 / (2 + cell.from_food))
				cell.node.modulate.a = 0.2
		
			
			

func _on_global_clock_timeout() -> void:
	for row in board:
		for cell in row:
			cell.from_home += 1
			cell.from_food += 1
