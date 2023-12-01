extends Sprite2D
class_name AimableItem


@onready var _ViewSniper: ViewSniperController = get_parent().get_parent().get_parent()
var interactuable := false
@export var item_name: String = "AimableItem"

var HoverMaterial: Material = load("res://materials/material_outline.tres")


func on_scope_in() -> void:
	if interactuable:
		set_material(HoverMaterial)


func on_scope_out() -> void:
	if interactuable:
		set_material(null)


# @abstract
func on_scope_click() -> void:
	pass
