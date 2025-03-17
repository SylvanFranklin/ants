extends CharacterBody2D
@onready var borda: Area2D = $"../borda"
const SPEED = 200.0
@export var direction := Vector2(randf() * 2 - 1, randf() * 2 -1)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const MONE = preload("res://mone.tscn")

func _ready():
	pass




func _physics_process(delta: float) -> void:
	if direction:
		velocity = direction.normalized() * SPEED
		
	rotation = velocity.x
	move_and_slide()


func _on_mone_squirter_timeout() -> void:
	var mone = MONE.instantiate() 
	get_parent().add_child(mone)# Replace with function body.
	mone.position = position
	
