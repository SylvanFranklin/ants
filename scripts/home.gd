extends Node2D
const ANT = preload("res://scenes/ant.tscn")
var counter = 0


func _ready() -> void:
	pass
		
func _process(delta: float) -> void:
	pass
	
func spawn_ant():
	var ant = ANT.instantiate()
	get_parent().add_child(ant)
	ant.position = position

func _on_spawner_timeout() -> void:
	for i in range(300):
		spawn_ant()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.bank_that_food_yo(body)
		

