extends CharacterBody2D
const SPEED = 3.0
const offsets = [[1, 1], [1, -1], [-1, 1], [-1, -1], [1, 0], [0, 1], [-1, 0], [0, -1]]
@export var direction := Vector2(randf() * 2 - 1, randf() * 2 -1)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const MONE = preload("res://mone.tscn")
@onready var world_boundry: Area2D = $WorldBoundry
enum State {SEEKING, HOMING}
var state: State = State.SEEKING;
@onready var frame_animation: AnimatedSprite2D = $FrameAnimation
var from_home: int = -1;
var from_food: int = INF
@onready var mone_squirter: Node2D = $MoneSquirter
@onready var scrap: Node2D = $scrap
@onready var scanner: CollisionShape2D = $scanner

func _ready():
	velocity = direction.normalized() * SPEED
	scrap.visible = false
		
func _process(delta: float) -> void:
	explore()

func _physics_process(delta: float) -> void:	
	velocity = direction.normalized() * SPEED;
	look_at(global_position + direction)
	position += velocity * (randf() + 0.2) 
	if randi() % 100 == 0: 
		frame_animation.pause()
	if randi() % 20 == 0:
		frame_animation.play()

func explore() -> void:
	if randi() % 50 == 0:
		if randi() % 2 == 0:
			direction += direction.orthogonal() * 0.4
		else:
			direction -= direction.orthogonal() * 0.4
	
func _on_mone_squirter_timeout() -> void:
	var board = get_parent().board
	var pos = boardinates(mone_squirter.global_position)
	mone_scan()

	if state == State.SEEKING:
		from_home += 1
		var bd = board[pos.x][pos.y].from_home
		board[pos.x][pos.y].from_home = min(bd, from_home)
	else: 
		from_food += 1
		var bd = board[pos.x][pos.y].from_food
		board[pos.x][pos.y].from_food = min(bd, from_food)
	
func boardinates(pos) -> Vector2:
	return pos / 32.0

func eat(node: Node2D):
	if not state == State.HOMING:
		state = State.HOMING;
		scrap.visible = true
		direction *= -1
		from_food = 0
		node.queue_free()
		
func bank_that_food_yo(node: Node2D):
	if not state == State.SEEKING:
		state = State.SEEKING
		scrap.visible = false
		direction *= -1
		from_home = 0


func mone_scan():
	var nays = rangle_the_nays(scanner.global_position)
	
	if state == State.SEEKING:
		var min_value = INF
		var chosen_nay = null
		
		for nay in nays: 
			if nay.from_food < min_value: 
				min_value = nay.from_food
				chosen_nay = nay
				
		if chosen_nay:
			direction = (chosen_nay.pos - boardinates(global_position))

			
	elif state == State.HOMING: 
		var min_value = INF
		var chosen_nay = null
		
		for nay in nays: 
			if nay.from_home < min_value: 
				min_value = nay.from_home
				chosen_nay = nay
		
		if chosen_nay:
			direction = (chosen_nay.pos - boardinates(global_position))
		
func rangle_the_nays(pos):
	var board = get_parent().board
	var viewport_size = get_viewport_rect().size
	var p = boardinates(pos)
	var nays = []
	var max = boardinates(viewport_size)
	for offset in offsets:
		var x = p.x + offset[0]
		var y = p.y + offset[1]
		if x > 0 and x < max.x and y > 0 and y < max.y:
			nays.append(board[x][y])
		
	return nays
