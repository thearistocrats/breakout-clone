extends StaticBody2D

func set_size(new_size) -> void:
	$CollisionShape2D.get_shape().size = new_size
	#$Sprite2D.position = new_size

func get_size() -> Vector2:
	return $CollisionShape2D.get_shape().size
