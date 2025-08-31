extends Node2D
# Make the paddle an Area2D or StaticBody2D in the scene; this script only moves the visual Node2D parent.
# If your collider is a child, the parent motion is enough.

@export var move_speed := 650.0
@export var half_width := 80.0  # keep in sync with your sprite/collider

func _ready() -> void:
	add_to_group("paddle")

func _process(delta: float) -> void:
	var input := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# also support A/D
	input += (Input.is_action_pressed("move_right") as int) - (Input.is_action_pressed("move_left") as int)

	position.x += input * move_speed * delta

	var screen := get_viewport_rect().size
	position.x = clamp(position.x, half_width + 8.0, screen.x - half_width - 8.0)
