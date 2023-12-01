extends Sprite2D
class_name WalkieController

@onready var _Area2D: Area2D = $Area2D
@onready var _ViewSheriff: ViewSheriffController = get_parent()
@onready var _AnimationPlayer: AnimationPlayer = get_node("AnimationPlayer")

var HoverMaterial: Material = load("res://materials/material_outline.tres")
var MaterialInteractuable: Material = load("res://materials/material_interactuable.tres")

var hanged := false

var next_dialog: Dialog:
	set(value):
		next_dialog = value
		if value:
			set_material(MaterialInteractuable)


func hang() -> void:
	hanged = true
	_AnimationPlayer.play("hang")


func unhang() -> void:
	if hanged:
		hanged = false
		_AnimationPlayer.play("unhang")


func _ready() -> void:
	_Area2D.connect("mouse_entered", _on_mouse_entered)
	_Area2D.connect("mouse_exited", _on_mouse_exited)
	_Area2D.connect("input_event", _on_input_event)


func _on_mouse_entered() -> void:
	if next_dialog:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		set_material(HoverMaterial)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if next_dialog:
		set_material(MaterialInteractuable)
	else:
		set_material(null)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click") && next_dialog:
		_on_mouse_exited()
		_ViewSheriff._Dialog.using_walkie = true
		_ViewSheriff._Dialog.load_dialog(next_dialog)
		if next_dialog.name == "12":
			# Ducts guy is dead, play next song
			Global.play(Global.MusicDivided1)
		next_dialog = null
