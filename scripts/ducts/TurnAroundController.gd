extends Button
class_name TurnAroundController

@onready var _Arrow: Sprite2D = $Arrow
@onready var _Shadow: Sprite2D = $Shadow
@onready var _Parent: ViewDuctsController = get_parent()

var MaterialLighten: Material = load("res://materials/material_lighten.tres")


func _ready() -> void:
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	connect("pressed", on_pressed)


func on_pressed() -> void:
	_Parent._on_turn_around()


func on_mouse_entered() -> void:
	if !_Parent.in_dialog:
		_Arrow.set_material(MaterialLighten)


func on_mouse_exited() -> void:
	_Arrow.set_material(null)
