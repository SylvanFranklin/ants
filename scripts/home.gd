extends Node
@onready var home: Sprite2D = $Home
const ANT = preload("res://scenes/ant.tscn")
var counter = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func spawn_ant():
	var ant = ANT.instantiate()
	add_child(ant)
	ant.position += Vector2(1, 1)
		
func _on_timer_timeout() -> void:
	counter += 1
	spawn_ant()
