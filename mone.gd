extends Node2D
@export var strength = 100.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var kind = "seek"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(deslta: float) -> void:
	#print(strength / 100)
	if kind == "food":
		sprite_2d.modulate = Color(10, 200, 10, 1)
	sprite_2d.modulate.a = strength / 20
	if strength == 0: 
		queue_free()

func _on_decay_timeout() -> void:
	if strength > 0:
		strength -= 1 # Replace with function body.
