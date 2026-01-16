class_name ball extends RigidBody2D

var speed: float = 300.0
@export var is_launched = false
var index = 0

func launch(new_impulse: Vector2) -> void:
	set_collision_layer(1)
	set_collision_mask(1)
	is_launched = true
	linear_velocity = Vector2.ZERO
	linear_damp = 0.0
	angular_damp = 0.0
	apply_central_impulse(new_impulse)

func _physics_process(_delta: float) -> void:
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * speed

signal ball_collided_with_brick(body, other)
signal ball_collided_with_paddle(body, other)
signal ball_collided_with_pickup(body, other)
func _on_body_entered(body: Node) -> void:
	if !is_launched: 
		return
	if body.is_in_group("brick"):
		ball_collided_with_brick.emit(self, body)
	if body.is_in_group("paddle"):
		ball_collided_with_paddle.emit(self, body)
	if body.is_in_group("pickup"):
		ball_collided_with_pickup.emit(self, body)
