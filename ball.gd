extends RigidBody2D

var speed: float = 300.0
@export var is_launched = false

func launch(new_impulse: Vector2) -> void:
	linear_velocity = Vector2.ZERO
	linear_damp = 0.0
	angular_damp = 0.0
	apply_central_impulse(new_impulse)

func _physics_process(delta: float) -> void:
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * speed

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("brick"):
		body.queue_free()
	if body.is_in_group("paddle"):
		var diff_in_velocity = linear_velocity - body._get_velocity()
		linear_velocity += diff_in_velocity
