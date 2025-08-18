extends Node2D

@export var ball_scene:PackedScene
@export var brick_scene:PackedScene
@export var paddle_scene:PackedScene

func _ready() -> void:
	build_bricks()

func build_bricks() -> void:
	var middle = get_viewport_rect().size/2
	for y in range(4):
		for x in range(5):
			var new_brick = brick_scene.instantiate()
			var spawn_position = Vector2(x * 180 + 40,y * 60 + 40)
			new_brick.position = spawn_position
			print("spawning brick at ", new_brick.position)
	
	
	
	'''
	var screen_size = get_viewport_rect().size
	var off_set = Vector2i(40,40)
	var brick_offset = 20
	var brick_size = Vector2i(160,40)
	var num_bricks = 100
	for i in range(num_bricks):
		var new_brick = brick_scene.instantiate()
		var spawn_position = Vector2i()
	
	pass
'''
