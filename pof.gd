extends Node2D
const FOOD = preload("res://food.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(200):
		var food = FOOD.instantiate()
		food.position.x += i % 100;
		food.position.y += i % 40;
		add_child(food)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
