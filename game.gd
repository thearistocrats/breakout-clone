extends Node2D

@export var ball_scene:PackedScene
@export var brick_scene:PackedScene
@export var paddle_scene:PackedScene

var screen_size:Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	build_bricks()
	spawn_paddle()
	spawn_ball()

func build_bricks() -> void:
	var middle = get_viewport_rect().size/2
	for y in range(4):
		for x in range(5):
			var new_brick = brick_scene.instantiate()
			var brick_size = new_brick.
			var spawn_position = Vector2(x * 180 + 40,y * 60 + 40)
			new_brick.position = spawn_position
			print("spawning brick at ", new_brick.position)
			add_child(new_brick)
			add_to_group("brick")

func spawn_paddle():
	pass
func spawn_ball():
	pass
