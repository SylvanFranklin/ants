extends Node2D
const ANT = preload("res://scenes/ant.tscn")
var counter = 0
var waves = 3

func _ready() -> void:
	pass
		
func _process(delta: float) -> void:
	pass
	
func spawn_ant():
	var ant = ANT.instantiate()
	get_parent().add_child(ant)
	ant.position = global_position
	ant.home = global_position

func _on_spawner_timeout() -> void:
	if waves >= 0:
		waves -= 1
		for i in range(30):
			spawn_ant()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.bank_that_food_yo(body)
