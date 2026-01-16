class_name Pickup extends Area2D

enum PickupType {
	WIDEPADDLE,
	MULTIBALL,
	TRIPLEBALL
	}

@export var type:PickupType

func _set_pickup(new_type:PickupType)-> void:
	self.type = new_type
	$AnimatedSprite2D.pause()
	$AnimatedSprite2D.frame = self.type
	

signal picked_up(pickup, collider)
func _on_body_entered(body: Node2D) -> void:
	picked_up.emit(self, body)
