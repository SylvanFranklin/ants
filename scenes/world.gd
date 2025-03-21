extends Node2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var grid: TileMapLayer = $GRID

class Cell:
	var distance_to_home = INF
	var distance_to_food = INF
	var pos: Vector2 = Vector2.ZERO
	var timer_for_food_mone: int = 100
	var timer_for_home_mone: int = 100
	
	func decay_mones() -> void:
		if timer_for_food_mone > 0:
			timer_for_food_mone -= 1
		else:
			distance_to_food = INF

		if timer_for_home_mone > 0:
			timer_for_home_mone -= 1
		else:
			distance_to_home = INF

@export var board = []
const CELL_SIZE = 16;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var size = get_viewport_rect().size
	var x_range: float = floor(size.x / CELL_SIZE)
	var y_range: float = floor(size.y / CELL_SIZE)
	
	for x in x_range:
		var row = []
		for y in y_range:
			var cell = Cell.new()
			cell.pos = Vector2(x, y)
			row.append(cell)
		board.append(row)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_global_clock_timeout() -> void:
	pass # Replace with function body.
	

	
