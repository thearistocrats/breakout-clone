extends Area2D

enum PickupType {
	WIDEPADDLE,
	MULTIBALL,
	TRIPLEBALL
	}

@export var type:PickupType

func _set_pickup(new_type:PickupType)-> void:
	self.type = new_type
	$AnimatedSprite2D.pause()
	$AnimatedSprite2D.play(self.type)

signal picked_up(type, index)
func _on_body_entered(body: Node2D) -> void:
	print("2")
	picked_up.emit(body.type, 0)
