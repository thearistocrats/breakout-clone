extends Node2D

@export var ball_scene: PackedScene
@export var brick_scene: PackedScene
@export var paddle_scene: PackedScene

var paddle: Node2D
var ball: Node2D
const COLS := 5
const ROWS := 4

func _ready() -> void:
	build_bricks()
	spawn_paddle()
	spawn_ball()

func build_bricks() -> void:
	# top-left padding
	var margin := Vector2(40, 40)
	var x_step := 180
	var y_step := 60
	for y in range(ROWS):
		for x in range(COLS):
			var new_brick: Node2D = brick_scene.instantiate()
			new_brick.position = margin + Vector2(x * x_step, y * y_step)
			add_child(new_brick)
			new_brick.add_to_group("brick")

func spawn_paddle() -> void:
	if is_instance_valid(paddle):
		paddle.queue_free()
	paddle = paddle_scene.instantiate()
	add_child(paddle)
	var screen = get_viewport_rect().size
	paddle.position = Vector2(screen.x * 0.5, screen.y - 60)

func spawn_ball() -> void:
	if is_instance_valid(ball):
		ball.queue_free()
	ball = ball_scene.instantiate()
	add_child(ball)
	# place it just above the paddle
	await get_tree().process_frame
	if is_instance_valid(paddle):
		ball.position = paddle.position + Vector2(0, -24)
	else:
		ball.position = get_viewport_rect().size * 0.5
	# give it an initial nudge
	if "launch" in ball:
		ball.launch()
	# reconnect in case of respawn
	if ball.has_signal("fell_out"):
		ball.disconnect("fell_out", Callable(self, "_on_ball_fell_out")) if ball.is_connected("fell_out", Callable(self, "_on_ball_fell_out")) else null
		ball.connect("fell_out", Callable(self, "_on_ball_fell_out"))

func _on_ball_fell_out() -> void:
	# simple respawn behavior
	spawn_ball()
