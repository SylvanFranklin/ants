extends Node2D
@export var strength = 100.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var decay = 30.0
@export var kind = "home"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(deslta: float) -> void:
	#print(strength / 100)
	if kind == "food":
		sprite_2d.modulate = Color(80, 200, 10, 1)

func _on_decay_timeout() -> void:
	if decay > 0:
		decay -= 1 # Replace with function body.
	else:
		queue_free()
