extends Node2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var grid: TileMapLayer = $GRID
@export var CELL_SIZE = 16.0;
@export var board = []
@onready var home: Node2D = $Home
var speed = 3.0
@export var mone_emission_speed = 0.1
const CELL = preload("res://cell.tscn")
const full_area = Vector2(200, 150)

func _ready() -> void:
	# Makes going to far from home worse and worse
	var too_far_factor = 999
	var center = home.global_position / CELL_SIZE
	
	for x in full_area.x:
		var row = []
		for y in full_area.y:
			var cell = CELL.instantiate()
			var pos = Vector2(x, y)
			var distance = pos.distance_to(center)
			cell.board_position = pos
			cell.global_position = pos * CELL_SIZE
			cell.size = CELL_SIZE
			row.append(cell)
			add_child(cell)
			cell.update()
			
		board.append(row)


func _process(delta: float) -> void:
	if Input.is_action_pressed('zoom in'):
		camera_2d.zoom += Vector2.ONE * delta
	elif Input.is_action_pressed('zoom out'):
		camera_2d.zoom -= Vector2.ONE * delta
	elif Input.is_action_pressed('pan left'):
		camera_2d.position += Vector2.LEFT
	elif Input.is_action_pressed('pan right'):
		camera_2d.position += Vector2.RIGHT
	elif Input.is_action_pressed('pan up'):
		camera_2d.global_position += Vector2.UP
	elif Input.is_action_pressed('pan down'):
		camera_2d.global_position += Vector2.DOWN

	if Input.is_action_pressed('scare'):
		var pos = floor(get_global_mouse_position() / CELL_SIZE)		
		board[pos.x][pos.y].from_food = 0
		board[pos.x][pos.y].update()
		
		


func _on_speed_value_changed(value: float) -> void:
	speed = value


func _on_mones_value_changed(value: float) -> void:
	mone_emission_speed = value
