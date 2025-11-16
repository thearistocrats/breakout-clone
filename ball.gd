extends RigidBody2D

var speed: float = 300.0
@export var is_launched = false

func launch(new_impulse: Vector2) -> void:
	is_launched = true
	linear_velocity = Vector2.ZERO
	linear_damp = 0.0
	angular_damp = 0.0
	set_collision_layer(1)
	apply_central_impulse(new_impulse)

func _physics_process(delta: float) -> void:
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * speed
		
signal collided_with_brick(brick)
signal collided_with_paddle(paddle)
signal collided_with_pickup(type)
func _on_body_entered(body: Node) -> void:
	if !is_launched: 
		print("is Lainched")
		return
	if body.is_in_group("brick"):
		collided_with_brick.emit(body)
	if body.is_in_group("paddle"):
		collided_with_paddle.emit(body)
	if body.is_in_group("pickup"):
		collided_with_pickup.emit(body)
