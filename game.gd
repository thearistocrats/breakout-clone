extends Node2D

@export var wall_scene:PackedScene
@export var ball_scene:PackedScene
@export var brick_scene:PackedScene
@export var paddle_scene:PackedScene

var screen_size:Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	build_walls()
	build_bricks()
	spawn_paddle()
	spawn_ball()

func build_walls() -> void:
	var top_wall = wall_scene.instantiate()
	var right_wall = wall_scene.instantiate()
	var left_wall = wall_scene.instantiate()
	top_wall.set_size(Vector2(screen_size.x, 1))
	right_wall.set_size(Vector2(1, screen_size.y))
	left_wall.set_size(Vector2(1, screen_size.y))
	top_wall.position = Vector2(screen_size.x/2, 0)
	right_wall.position = Vector2(0, screen_size.y/2)
	left_wall.position = Vector2(screen_size.x, screen_size.y/2)
	
func build_bricks() -> void:
	var middle = screen_size/3
	for y in range(4):
		for x in range(5):
			var new_brick = brick_scene.instantiate()
			var brick_size = new_brick.get_size()
			var spawn_position = Vector2(x * (brick_size.x + 40),y * (brick_size.y + 10))
			new_brick.position = spawn_position + middle
			add_child(new_brick)
			add_to_group("brick")

func spawn_paddle():
	pass
func spawn_ball():
	var new_ball = ball_scene.instantiate()
	new_ball.position = screen_size/4
	new_ball.launch(Vector2(400,400))
	add_child(new_ball)
	add_to_group("ball")
