extends Node2D

@export var wall_scene:PackedScene
@export var ball_scene:PackedScene
@export var brick_scene:PackedScene
@export var paddle_scene:PackedScene

var paddle:CharacterBody2D
var bricks = []
var ball:RigidBody2D

var screen_size:Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	build_walls()
	build_bricks()
	spawn_paddle()
	spawn_ball()

func _process(delta: float) -> void:
	
	var mouse_input = get_global_mouse_position()
	
	paddle.position.x = mouse_input.x
	paddle.current_velocity = (paddle.position - paddle.prev_pos) / delta
	paddle.prev_pos = paddle.position
	
	if !ball.is_launched:
		ball.position.x = mouse_input.x
		
	if Input.is_action_just_pressed("launch"):
		#respawns the ball, 
		#for some reason this fixes the issue of the ball teleporting to a random poistion when launched
		ball.queue_free()
		ball = ball_scene.instantiate()
		ball.position = paddle.position
		ball.position.y -= 40
		add_child(ball)
		
		var launch_angle = Vector2(randf_range(0,1), randfn(-1,1)*-1)
		var launch_speed = 400
		ball.is_launched = true
		ball.launch(launch_angle * launch_speed)

func build_wall(size: Vector2, pos: Vector2) -> Node2D:
	var wall = wall_scene.instantiate()
	
	var shape = wall.get_node("CollisionShape2D").shape.duplicate()
	shape.size = size
	wall.get_node("CollisionShape2D").shape = shape
	
	wall.position = pos
	return wall

func build_walls() -> void:
	var top_wall = build_wall(Vector2(screen_size.x, 1), Vector2(screen_size.x / 2, 0))
	add_child(top_wall)
	var right_wall = build_wall(Vector2(1, screen_size.y), Vector2(screen_size.x, screen_size.y / 2))
	add_child(right_wall)
	var left_wall = build_wall(Vector2(1, screen_size.y), Vector2(0, screen_size.y / 2))
	add_child(left_wall)
	
func build_bricks() -> void:
	var middle = screen_size/12
	for y in range(12):
		for x in range(9):
			var new_brick = brick_scene.instantiate()
			var brick_size = new_brick.get_size()
			var spawn_position = Vector2(x * (brick_size.x + 40),y * (brick_size.y + 10))
			new_brick.position = spawn_position + middle
			add_child(new_brick)

func spawn_paddle():
	paddle = paddle_scene.instantiate()
	paddle.position = Vector2(screen_size.x/2, screen_size.y)
	add_child(paddle)
	
func spawn_ball():
	ball = ball_scene.instantiate()
	ball.position = paddle.position
	ball.position.y -= 40
	add_child(ball)
