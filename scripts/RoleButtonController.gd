extends Node2D
class_name RoleButtonController


@onready var _Button: Button = get_node("Button")
@onready var _Sprite2D: Sprite2D = get_node("Sprite2D")
@onready var _Parent: RolesController = get_parent()

var MaterialLighten: Material = load("res://materials/material_lighten.tres")
var MaterialBlackAndWhite: Material = load("res://materials/material_black_and_white.tres")
var MaterialWhiteNoise: Material = load("res://materials/material_white_noise.tres")

var role: RolesController.Role
var disabled: bool = false
var dead := false


func _ready() -> void:
	_Button.connect("pressed", _on_pressed)
	_Button.connect("mouse_entered", on_mouse_entered)
	_Button.connect("mouse_exited", on_mouse_exited)


func _on_pressed() -> void:
	if !disabled:
		_Parent.change_scene(role)


func on_mouse_entered() -> void:
	if !disabled && !dead:
		_Sprite2D.set_material(MaterialLighten)


func on_mouse_exited() -> void:
	if !disabled && !dead:
		_Sprite2D.set_material(null)


func set_disabled(_disabled: bool) -> void:
	disabled = _disabled
	if !dead:
		if disabled:
			_Sprite2D.set_material(MaterialBlackAndWhite)
		else:
			_Sprite2D.set_material(null)


func set_dead(_dead: bool) -> void:
	dead = _dead
	if dead:
		_Sprite2D.set_material(MaterialWhiteNoise)
	else:
		_Sprite2D.set_material(null)
