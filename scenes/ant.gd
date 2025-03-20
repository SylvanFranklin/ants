extends CharacterBody2D
const SPEED = 0.8
@export var direction := Vector2(randf() * 2 - 1, randf() * 2 -1)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const MONE = preload("res://mone.tscn")
@onready var world_boundry: Area2D = $WorldBoundry
enum State {SEEKING, HOMING}
var state: State = State.SEEKING;
@onready var frame_animation: AnimatedSprite2D = $FrameAnimation
var distance_from_objective: int = 0;
var viewport_size = get_viewport_rect().size
@onready var scrap: Node2D = $scrap

func _ready():
	velocity = direction.normalized() * SPEED
	scrap.visible = false
	
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
			
			
func explore() -> void:
	if randi() % 2 == 0:
		direction += direction.orthogonal() * 0.4
	else:
		direction -= direction.orthogonal() * 0.4
	
	var n = neighbors()
	var lowest = INF
	var chosen_nay
	for nay in n:
		if nay.distance_to_home < lowest:
			chosen_nay = nay
			if state == State.HOMING:
				lowest = nay.distance_to_home
			else:
				lowest = nay.distance_to_food
	
	if chosen_nay:		
		var ant_pos = get_board_position()
		var turn_dir = chosen_nay.pos - ant_pos
		
		if state == State.HOMING:
			direction = turn_dir
	
func _on_mone_squirter_timeout() -> void:
	distance_from_objective += 1
	var board = get_parent().get_parent().board
	var board_pos = get_board_position()
	
	if state == State.SEEKING:
		var what_the_board_has = board[board_pos.x][board_pos.y].distance_to_home 
		var what_we_have = distance_from_objective
		board[board_pos.x][board_pos.y].distance_to_home = min(what_the_board_has, what_we_have)
	else:
		var what_the_board_has = board[board_pos.x][board_pos.y].distance_to_food 
		var what_we_have = distance_from_objective
		print("we",what_we_have)
		print("board",what_the_board_has)
		board[board_pos.x][board_pos.y].distance_to_food = min(what_the_board_has, what_we_have)
		print("update",min(what_the_board_has, what_we_have))
		
	var mone = MONE.instantiate() 
	if state == State.SEEKING: 
		mone.kind = 'seek'
	else: 
		mone.kind = 'food'
			
	get_parent().add_child(mone)# Replace with function body.
	mone.position = Vector2(10*floor(position.x/10),floor(position.y/10)*10)


func eat(node: Node2D):
	if not state == State.HOMING:
		state = State.HOMING;
		scrap.visible = true
		distance_from_objective = 0
		
func bank_that_food_yo(node: Node2D):
	if not node.state == State.SEEKING:
		state = State.SEEKING
		scrap.visible = true	
		distance_from_objective = 0
		
func get_board_position() -> Vector2:
	var x: int = floor(global_position.x / 10)
	var y: int = floor(global_position.y / 10)
	return Vector2(x, y)
	

func neighbors() -> Array: 
	var board = get_parent().get_parent().board
	var board_pos = get_board_position()
	var n = []
	var maxY = len(board[0])
	var maxX = len(board)
	var offsets = [
		[1, 1], [1, 0], [0, 1], 
		[-1, 0], [0, -1], [-1, 1], 
		[1, -1], [-1, -1]
	]
		
	for offset in offsets:
		if board_pos.x + offset[0] < maxX and board_pos.x + offset[0] > 0 and board_pos.y + offset[1] < maxY and board_pos.y + offset[1] > 0:
			n.append(board[board_pos.x+offset[0]][board_pos.y+offset[1]])

	return n
	
