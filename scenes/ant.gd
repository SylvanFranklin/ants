extends CharacterBody2D
var SPEED = 2.1
const offsets = [[1, 1], [1, -1], [-1, 1], [-1, -1], [1, 0], [0, 1], [-1, 0], [0, -1]]
@export var direction := Vector2(randf() * 2 - 1, randf() * 2 -1)
enum State {SEEKING, HOMING, EMPTY_HANDED}
var state: State = State.SEEKING;
var from_home: int = 0;
var from_food: int = INF
var nay_blacklist = []
var home = Vector2(0, 0)
@onready var clock: Timer = $MoneSquirter/TheClockWork
@onready var respawn: Timer = $Respawn
@onready var mone_squirter: Node2D = $MoneSquirter
@onready var scrap: Node2D = $scrap
@onready var scanner: CollisionShape2D = $scanner
@onready var frame_animation: AnimatedSprite2D = $FrameAnimation
@onready var world_boundry: Area2D = $WorldBoundry

func _ready():
	velocity = direction.normalized() * SPEED
	scrap.visible = false

		
func _process(delta: float) -> void:
	explore()
	SPEED = get_parent().speed
	clock.wait_time = get_parent().mone_emission_speed
	
func _physics_process(delta: float) -> void:	
	velocity = direction.normalized() * SPEED;
	look_at(global_position + direction)
	if move_and_collide(velocity * 100 * delta):
		direction *= -1

func explore() -> void:
	if randi() % 50 == 0:
		if randi() % 2 == 0:
			direction += direction.orthogonal() * 0.4
		else:
			direction -= direction.orthogonal() * 0.4
	
func _on_mone_squirter_timeout() -> void:
	var board = get_parent().board
	var pos = boardinates(mone_squirter.global_position)
	var cell = board[pos.x][pos.y]
	
	mone_scan()
	from_home += 4
	from_food += 5
	turn_around()
	if cell:
		if state == State.SEEKING:
			cell.from_home = min(cell.from_home, from_home)
			cell.walk()
		elif state == State.HOMING: 
			cell.from_food = min(cell.from_food, from_food)
			cell.walk()
	
func boardinates(pos) -> Vector2:
	var CELL_SIZE = get_parent().CELL_SIZE
	return pos / CELL_SIZE

func eat(node: Node2D):
	if not state == State.HOMING:
		state = State.HOMING;
		scrap.visible = true
		direction *= -1
		from_food = 0
		node.eat()
		
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
				
		if chosen_nay and chosen_nay not in nay_blacklist:
			direction = (chosen_nay.board_position - boardinates(global_position))
			if len(nay_blacklist) > 5:
					nay_blacklist.clear()
			
			nay_blacklist.append(chosen_nay)
			
	elif state == State.HOMING or state == State.EMPTY_HANDED: 
		var min_value = INF
		var chosen_nay = null
		
		for nay in nays: 
			if nay.from_home < min_value: 
				min_value = nay.from_home
				chosen_nay = nay
		
		if chosen_nay and chosen_nay not in nay_blacklist:
			direction = (chosen_nay.board_position - boardinates(global_position))
			if len(nay_blacklist) > 5:
					nay_blacklist.clear()
			nay_blacklist.append(chosen_nay)
		
			
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

func turn_around():
	var away = home.distance_to(global_position)
	
	if away > 500:
		global_position = home
		state = State.SEEKING
		direction = Vector2(randf() * 2 -1, randf() * 2 -1)
	elif away > 450:
		state = State.EMPTY_HANDED

