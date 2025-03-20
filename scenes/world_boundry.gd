extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	
	var size = get_viewport().size
	if body.global_position.x < 0:
		body.global_position.x = 0
	if body.global_position.y < 0:
		body.global_position.y = 0 
		
	if body.global_position.x > size.x:
		body.global_position.x = size.x
	if body.global_position.y > size.y:
		body.global_position.y = size.y
	
	body.direction *= -1
	
