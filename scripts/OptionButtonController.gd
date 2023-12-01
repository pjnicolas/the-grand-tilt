extends Button
class_name OptionButtonController


@onready var _Text: RichTextLabel = get_node("Text")
@onready var _DialogController: DialogController = get_parent().get_parent().get_parent()
var option: DialogLine
var n: int = 1
var text_padding := Vector2(10, 0)


func _ready() -> void:
	connect("pressed", _on_pressed)
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	_Text.set_text(" " + str(n) + ". " + option.text)
	_Text.position = text_padding
	_Text.size = size - text_padding * 2


func _on_pressed() -> void:
	_DialogController._on_option_pressed(option)


func on_mouse_entered() -> void:
	_Text.add_theme_color_override("default_color", Color.YELLOW)


func on_mouse_exited() -> void:
	_Text.add_theme_color_override("default_color", Color.WHITE)


func set_option(_option: DialogLine, _position: Vector2, _size: Vector2, _n: int) -> void:
	option = _option
	n = _n
	position = _position
	size = _size
