extends Node2D

var from_home = 999
var from_food = INF
var board_position: Vector2
var size = 32.0
@export var margin = 0.6
@onready var border: Sprite2D = $Border
@onready var mone: Sprite2D = $Mone
var frequency = 0.0
	
func update():
	border.region_rect = Rect2(Vector2(0, 0), Vector2(size, size))
	var blue: float = (13.0 / from_home)
	var green: float = (13.0 / from_food)
	var red: float = (blue + green / 2)
	mone.modulate = Color(0.0, green, blue, frequency)

func walk():
	frequency = min(frequency + 0.01, 0.6)
	update()

func _on_decayer_timeout() -> void:
	frequency = max(0, frequency - 0.001)
	mone.modulate.a = frequency
