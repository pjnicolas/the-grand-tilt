extends Node2D
class_name DuctVentController


@onready var _Sprite: Sprite2D = $Sprite2D
@onready var _Area2D: Area2D = $Area2D
@onready var _ViewDucts: ViewDuctsController = get_parent().get_parent()
var dialog: Dialog


func _ready() -> void:
	_Area2D.connect("mouse_entered", _on_mouse_entered)
	_Area2D.connect("mouse_exited", _on_mouse_exited)
	_Area2D.connect("input_event", _on_input_event)


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	_Sprite.modulate = Color(2, 2, 2, 1)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	_Sprite.modulate = Color(1, 1, 1, 1)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		_ViewDucts.on_click_vents(dialog)
