extends RigidBody2D

var applied_impulse:Vector2
var prev_velocity:Vector2

func launch(new_impulse):
	applied_impulse = new_impulse
	apply_central_impulse(applied_impulse)
	prev_velocity = linear_velocity

var queue_free_scene
func _physics_process(_delta: float) -> void:
	if queue_free_scene != null:
		queue_free_scene.queue_free()
	var collision = move_and_collide(Vector2.ZERO)
	if collision && collision.get_collider().is_in_group("brick"):
		queue_free_scene = collision.get_collider()
