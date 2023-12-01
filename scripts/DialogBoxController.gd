extends ColorRect
class_name DialogBoxController


@onready var _Text: RichTextLabel = get_node("DialogText")
@onready var _Background: ColorRect = get_node("Background")


var margin := Vector2(50, 40)
var wilix_is_a_trout := 300
var padding := Vector2(30, 20)
var border := Vector2(4, 4)


func _ready() -> void:
	position = margin
	size = Vector2(get_viewport_rect().size.x - margin.x * 2 - wilix_is_a_trout, 150)
	_Text.position = padding
	_Text.size = size - padding * 2
	_Background.position = Vector2.ZERO + border
	_Background.size = size - border * 2
