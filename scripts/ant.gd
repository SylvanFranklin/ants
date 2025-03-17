extends Node2D
@onready var home: Sprite2D = $"../Home"
@onready var ant: Node2D = $"."
var velocity = Vector2(0,0)
var pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pos = home.position
	var velocity = Vector2(0,0) 
	var speed = 3000
	var xDir = 0
	var yDir = 0
	
	xDir = (2*randf())-1
	yDir = (2*randf())-1
	velocity = Vector2(xDir,yDir).normalized() * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity*delta


func boundary():
	if pos.x < 0:
		return 0
