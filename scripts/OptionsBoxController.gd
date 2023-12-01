extends ColorRect
class_name OptionBoxController


var padding := Vector2(80, 20)
var border := Vector2(4, 4)


func _ready() -> void:
	size = Vector2(get_viewport_rect().size.x - padding.x * 2, 0)
	position.x = padding.x
	position.y = 0


func set_size_pos(_size: Vector2, _position: Vector2) -> void:
	size = _size
	position = _position
