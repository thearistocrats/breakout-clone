extends CharacterBody2D

signal fell_out

@export var speed: float = 520.0
var dir := Vector2(0, -1).normalized()

func launch() -> void:
	# slight randomization to avoid straight lines
	var angle := deg_to_rad(randf_range(-20.0, 20.0))
	dir = Vector2(0, -1).rotated(angle).normalized()

func _physics_process(delta: float) -> void:
	var screen := get_viewport_rect().size

	# move and handle collisions with physics bodies (paddle/bricks/walls made of bodies)
	var motion := dir * speed * delta
	var collision := move_and_collide(motion)
	if collision:
		# reflect direction across the collision normal
		dir = dir.bounce(collision.get_normal()).normalized()

		# brick hit?
		var col := collision.get_collider()
		if is_instance_valid(col) and col.is_in_group("brick"):
			col.queue_free()

		# paddle hit? tweak bounce based on where we hit the paddle
		if is_instance_valid(col) and col.is_in_group("paddle"):
			var local_x := (global_position.x - col.global_position.x)
			dir.x = clamp(local_x / 80.0, -0.9, 0.9) # 80px half-width tuning
			dir.y = -abs(dir.y)
			dir = dir.normalized()

	# manual screen-edge walls (left/right/top). Bottom is out-of-bounds.
	if global_position.x <= 8 and dir.x < 0:
		dir.x = -dir.x
	if global_position.x >= screen.x - 8 and dir.x > 0:
		dir.x = -dir.x
	if global_position.y <= 8 and dir.y < 0:
		dir.y = -dir.y

	# fell out
	if global_position.y > screen.y + 30:
		emit_signal("fell_out")
		queue_free()
