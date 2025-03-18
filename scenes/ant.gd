extends CharacterBody2D
const SPEED = 2.0
@export var direction := Vector2(randf() * 2 - 1, randf() * 2 -1)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const MONE = preload("res://mone.tscn")
const SCRAP = preload("res://scrap.tscn")

func _ready():
	velocity = direction.normalized() * SPEED


func _physics_process(delta: float) -> void:
	if position.x < 0:
		velocity.x *= -1
	if position.x > 1152:
		velocity.x *= -1
	if position.y < 0:
		velocity.y *= -1
	if position.y > 648:
		velocity.y *= -1
		
		
		
	position += velocity
	#rotation = velocity.x
	#var collision = move_and_collide(velocity * delta)
	#
	#if collision:
		#velocity = velocity.bounce(collision.get_normal())
		#if collision.get_collider().has_method("hit"):
			#collision.get_collider().hit()
			
	

func _on_mone_squirter_timeout() -> void:
	var mone = MONE.instantiate() 
	get_parent().add_child(mone)# Replace with function body.
	mone.position = position

func pickup_scrap():
	var scrap = SCRAP.instantiate()
	add_child(scrap)
	scrap.position = position
	
