extends Node2D

@export var ball_scene:PackedScene
@export var brick_scene:PackedScene
@export var paddle_scene:PackedScene
@export var pickup_scene:PackedScene

var BrickType = Brick.BrickType
var PickupType = Pickup.PickupType

var paddle:CharacterBody2D
var bricks = []
var balls = []
var first_ball:ball

var screen_size:Vector2
var is_launched:bool

func _ready() -> void:
	is_launched = false
	screen_size = get_viewport_rect().size
	spawn_paddle()
	var paddle_position = Vector2(paddle.position.x, paddle.position.y-40)
	first_ball = balls[spawn_ball(paddle_position)]
	build_bricks()
	spawn_pickups()

func _process(delta: float) -> void:
	var mouse_input = get_global_mouse_position()
	
	paddle.position.x = mouse_input.x
	paddle.current_velocity = (paddle.position - paddle.prev_pos) / delta
	paddle.prev_pos = paddle.position
	
	if (!is_launched):
		first_ball.position.x = paddle.position.x
		paddle.ready_paddle()
	
func _input(event: InputEvent) -> void:
	if (event.is_action(&'launch') && !is_launched):
		first_ball.queue_free()
		balls.erase(balls[0])
		var spawn_position = Vector2(paddle.position.x, paddle.position.y-40)
		spawn_ball(spawn_position)
		launch_ball(0)
		is_launched = true
	
func build_bricks() -> void:
	var middle = screen_size/2
	var i = 0
	for y in range(3):#12
		for x in range(2):#9
			var new_brick = brick_scene.instantiate()
			var brick_size = new_brick.get_size()
			var spawn_position = Vector2(x * (brick_size.x + 40),y * (brick_size.y + 10))
			new_brick.position = spawn_position + middle
			new_brick._set_brick(i, 0)
			add_child(new_brick)
			bricks.append(new_brick)
			i += 1

func spawn_paddle():
	paddle = paddle_scene.instantiate()
	paddle.position = Vector2(screen_size.x/2, screen_size.y)
	add_child(paddle)
	
func spawn_ball(spawn_position:Vector2) -> int:
	var new_ball = ball_scene.instantiate()
	new_ball.position = spawn_position
	add_child(new_ball)
	balls.append(new_ball)
	return balls.size()-1

func launch_ball(i:int):
	var ball = balls[i]
	ball.connect("ball_collided_with_brick", _on_ball_collide_brick)
	ball.connect("ball_collided_with_paddle", _on_ball_collide_paddle)
	#ball.connect("ball_collided_with_pickup", _on_ball_collide_pickup)

	var launch_angle = Vector2(1,-1)
	var launch_speed = 400
	ball.launch(launch_angle * launch_speed)

func spawn_pickups():
	for i in range(3):
		var spawn_position = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
		var new_pickup = pickup_scene.instantiate()
		new_pickup.position = spawn_position
		new_pickup.connect("picked_up", _on_pickup)
		new_pickup._set_pickup(i)
		add_child(new_pickup)
		
signal bricks_cleared
func _on_ball_collide_brick(ball, brick):
	print("ball ", ball, " collided with ", brick)
	brick.queue_free()
	bricks.erase(brick)
	if bricks.size() == 0:
		bricks_cleared.emit()
	print("bricks_remaining, ", bricks.size())
func _on_ball_collide_paddle(ball, paddle):
	var diff_in_velocity = ball.linear_velocity - paddle._get_velocity()
	ball.linear_velocity += diff_in_velocity
	
func _on_pickup(pickup, collider):
	if !is_launched: return
	print("picked up ", pickup.type)
	if (collider.is_in_group("paddle")):
		pass
	if (collider.is_in_group("paddle")):
		pass
	match pickup.type:
		PickupType.WIDEPADDLE:
			paddle.scale.x *= 2
			start_wide_paddle_timer()
		PickupType.MULTIBALL:
			for ball in balls:
				call_deferred("spawn_multiball", ball.position)
		PickupType.TRIPLEBALL:
			call_deferred("spawn_tripleball", paddle.position)
		_:
			print_debug(pickup.type, "not yet implemented")
	pickup.queue_free()

func start_wide_paddle_timer():
	await get_tree().create_timer(4).timeout
	paddle.scale.x /= 2

func spawn_multiball(spawn_position: Vector2) -> void:
	for i in range(3):
		var index = spawn_ball(spawn_position)
		launch_ball(index)

func spawn_tripleball(spawn_position: Vector2) -> void:
	for i in range(3):
		var index = spawn_ball(spawn_position)
		launch_ball(index)
