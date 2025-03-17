extends Node
@onready var home: Sprite2D = $Home
const ANT = preload("res://scenes/ant.tscn")
@onready var timer: Timer = $"../Timer"

func _process(delta: float) -> void:
	pass
		
		
func _on_timer_timeout() -> void:
	var ant = ANT.instantiate()
	add_child(ant)
	ant.position += Vector2(1, 1)
