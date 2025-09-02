extends StaticBody2D

func get_size() -> Vector2:
	return $CollisionShape2D.get_shape().size
