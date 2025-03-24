extends Node2D
@export var counter_food = 0;
@export var counter_home = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_scanner_area_entered(area: Area2D) -> void:
	if area.name == 'mone':
		if area.get_parent().kind == 'home':
			counter_home += 1
		elif area.get_parent().kind == "food":
			counter_food += 1
			
	elif area.name == 'home':
		counter_home += INF
	elif area.name == 'food':
		counter_food += INF

func _on_reseter_timeout() -> void:
	counter_food = 0
	counter_home = 0 
