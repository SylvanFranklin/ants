extends CharacterBody2D
const SPEED = 2.0
@export var direction := Vector2(randf() * 2 - 1, randf() * 2 -1)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const MONE = preload("res://mone.tscn")
@onready var world_boundry: Area2D = $WorldBoundry
enum State {SEEKING, HOMING}
var state: State = State.SEEKING;
@onready var frame_animation: AnimatedSprite2D = $FrameAnimation
var distance_from_objective: int = -1;
var viewport_size = get_viewport_rect().size
@onready var scrap: Node2D = $scrap
@onready var grid: TileMapLayer = $GRID
@onready var scanner_1: Node2D = $Scanner1
@onready var scanner_2: Node2D = $Scanner2
@onready var scanner_3: Node2D = $Scanner3


func _ready():
	velocity = direction.normalized() * SPEED
	scrap.visible = false

	
func _physics_process(delta: float) -> void:	
	explore()
	velocity = direction.normalized() * SPEED;
	look_at(global_position + direction)
	position += velocity * (randf() + 0.2) 
	
	if randi() % 100 == 0: 
		frame_animation.pause()
	
	if randi() % 20 == 0:
		frame_animation.play()
			
func sniff_out_the_mones() -> void:
	var n = neighbors()
	var lowest_h = INF
	var lowest_f = INF
	var chosen_nay_h
	var chosen_nay_f
	for nay in n:
		if nay.distance_to_home < lowest_h:
			lowest_h = nay.distance_to_home
			chosen_nay_h = nay
		if nay.distance_to_food < lowest_f:
			lowest_f = nay.distance_to_food
			chosen_nay_f = nay
	
	if chosen_nay_h and state == State.HOMING:		
		var ant_pos = get_board_position()
		var turn_dir = chosen_nay_h.pos - ant_pos
		direction = turn_dir
	if chosen_nay_f and state == State.SEEKING:
		var ant_pos = get_board_position()
		var turn_dir = chosen_nay_f.pos - ant_pos
		direction = turn_dir

func explore() -> void:
	if not mone_scan():
		if randi() % 50 == 0:
			if randi() % 2 == 0:
				direction += direction.orthogonal() * 0.4
			else:
				direction -= direction.orthogonal() * 0.4
			
	
	
	
func _on_mone_squirter_timeout() -> void:
	#sniff_out_the_mones()
	distance_from_objective += 1
	#var board = get_parent().board
	#var board_pos = get_board_position()
	#
	#if state == State.SEEKING:
		#var what_the_board_has = board[board_pos.x][board_pos.y].distance_to_home 
		#var what_we_have = distance_from_objective
		#board[board_pos.x][board_pos.y].distance_to_home = min(what_the_board_has, what_we_have)
	#else:
		#var what_the_board_has = board[board_pos.x][board_pos.y].distance_to_food 
		#var what_we_have = distance_from_objective
		#board[board_pos.x][board_pos.y].distance_to_food = min(what_the_board_has, what_we_have)
		#
	var mone = MONE.instantiate() 
	if state == State.SEEKING: 
		mone.kind = 'seek'
	else: 
		mone.kind = 'food'
			
	get_parent().add_child(mone)# Replace with function body.
	mone.position = global_position


func eat(node: Node2D):
	if not state == State.HOMING:
		state = State.HOMING;
		scrap.visible = true
		distance_from_objective = 0
		
func bank_that_food_yo(node: Node2D):
	if not node.state == State.SEEKING:
		state = State.SEEKING
		scrap.visible = false	
		distance_from_objective = 0
		
func get_board_position() -> Vector2:
	var x: int = floor(global_position.x / 16)
	var y: int = floor(global_position.y / 16)
	return Vector2(x, y)	

func neighbors() -> Array: 
	var board = get_parent().board
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
	

func mone_scan() -> bool:
	if state == State.SEEKING: 
		var target = scanner_2
		if target.counter_food <= scanner_1.counter_food:
			target = scanner_1
		if target.counter_food <= scanner_3.counter_food:
			target = scanner_3
		if target.counter_food > 0:
			direction += (target.global_position - global_position).normalized()
			return true
	elif state == State.HOMING:
		var target = scanner_2
		if target.counter_home <= scanner_1.counter_home:
			target = scanner_1
		if target.counter_home <= scanner_3.counter_home:
			target = scanner_3
		if target.counter_home > 0:
			direction += (target.global_position - global_position).normalized()

			return true
			
	return false
