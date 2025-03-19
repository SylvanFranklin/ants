extends Node2D
@export var strength = 100.0
@onready var sprite_2d: Sprite2D = $Sprite2D
enum MoneKind {FOOD, MONE}
@export var kind = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(strength / 100)
	sprite_2d.modulate.a = strength / 100
	if strength == 0: 
		queue_free()

func _on_decay_timeout() -> void:
	if strength > 0:
		strength -= 1 # Replace with function body.
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	body.direction +=  global_position - body.global_position
