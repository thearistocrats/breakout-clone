extends RigidBody2D

var speed: float = 300.0
@export var is_launched = false

func launch(new_impulse: Vector2) -> void:
	set_collision_layer(1)
	set_collision_mask(1)
	is_launched = true
	linear_velocity = Vector2.ZERO
	linear_damp = 0.0
	angular_damp = 0.0
	apply_central_impulse(new_impulse)

func _physics_process(delta: float) -> void:
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * speed

signal collided_with_brick(index)
signal collided_with_paddle(paddle)
signal collided_with_pickup(type)
func _on_body_entered(body: Node) -> void:
	if !is_launched: 
		print("is Lainche5")
		return
	if body.is_in_group("brick"):
		collided_with_brick.emit(body.index)
	if body.is_in_group("paddle"):
		collided_with_paddle.emit(body)
	if body.is_in_group("pickup"):
		collided_with_pickup.emit(body.type)
