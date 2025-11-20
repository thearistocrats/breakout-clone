class_name Brick extends StaticBody2D

enum BrickType {
	BRICK
}

var index:Vector2i
var type:BrickType

func _set_brick(new_index:Vector2i, new_type:BrickType) -> void:
	self.index = new_index
	self.type = new_type

func _set_index(new_index:Vector2i) -> void:
	self.index = new_index

func get_size() -> Vector2:
	return $CollisionShape2D.get_shape().size
