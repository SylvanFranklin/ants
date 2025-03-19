extends CharacterBody2D
const SPEED = 2.0
@export var direction := Vector2(randf() * 2 - 1, randf() * 2 -1)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const MONE = preload("res://mone.tscn")
const SCRAP = preload("res://scrap.tscn")
@onready var world_boundry: Area2D = $WorldBoundry
enum State {SEEKING, HOMING}
var state: State = State.SEEKING;
@onready var frame_animation: AnimatedSprite2D = $FrameAnimation

func _ready():
	velocity = direction.normalized() * SPEED

func _physics_process(delta: float) -> void:
	
	if randi() % 50 == 0: 
		explore()
		
	velocity = direction.normalized() * SPEED;
	look_at(global_position + direction)
	position += velocity * (randf() + 0.2) 
	
	if randi() % 100 == 0: 
		frame_animation.pause()
	
	if randi() % 20 == 0:
		frame_animation.play()
		
	
	#var collision = move_and_collide(velocity * delta)
	#if collision:
		#velocity = velocity.bounce(collision.get_normal())
		#if collision.get_collider().has_method("hit"):
			#collision.get_collider().hit()
	
func explore() -> void:
	if randi() % 2 == 0:
		direction += direction.orthogonal() * 0.4
	else:
		direction -= direction.orthogonal() * 0.4
		
	

func _on_mone_squirter_timeout() -> void:
	var mone = MONE.instantiate() 
	get_parent().add_child(mone)# Replace with function body.
	mone.position = position

func pickup_scrap():
	var scrap = SCRAP.instantiate()
	add_child(scrap)
	scrap.position = position
	
func eat(node: Node2D):
	if not state == State.HOMING:
		var scrap = SCRAP.instantiate()
		state = State.HOMING;
		add_child(scrap)
		node.queue_free()



