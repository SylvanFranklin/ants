extends Node2D
@onready var area_2d: Area2D = $Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	pass

	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("eat"):
		body.eat(self)
