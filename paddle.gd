extends CharacterBody2D

var screen_size : Vector2
var current_velocity : Vector2
var prev_pos: Vector2

func _ready() -> void:
	prev_pos = position

func _get_velocity() -> Vector2:
	return current_velocity
