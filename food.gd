extends Node2D
@onready var area_2d: Area2D = $Area2D
@export var food: int = 1000
var scaler = 10
@onready var sprite: Sprite2D = $Food

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(food, food) / scaler

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	pass
	pass # ending this
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("eat"):
		body.eat(self)
		
func eat() -> void:
	food -= 1
	if food > 0:
		food -= 1
	else:
		queue_free()
		
	scale = Vector2(food, food) / scaler

