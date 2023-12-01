extends Button
class_name OpenMapController

var MaterialLighten: Material = load("res://materials/material_lighten.tres")


@onready var _Sprite: Sprite2D = $Sprite2D


@onready var _MapFloor1: Node2D = get_parent().get_node("Maps/MapFloor1")
@onready var _MapFloor2: Node2D = get_parent().get_node("Maps/MapFloor2")
@onready var _Map := _MapFloor2
@onready var _ViewDucts: ViewDuctsController = get_parent()


var showing_map := false
var mouse_hover := false


func _ready() -> void:
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	# connect("pressed", on_pressed)


func _process(_delta: float) -> void:
	if !showing_map:
			if mouse_hover && Input.is_action_just_pressed("left_click"):
				showing_map = true
				_MapFloor1.visible = false
				_MapFloor2.visible = false
				_Map.visible = true
				# _ViewDucts.maze.player_direction
				var first_node: MazeNode = _ViewDucts.maze.get_start_node_next()
				var _StartCell: Node2D = _Map.get_node("StartCell")
				var _PlayerMarker: Sprite2D = _Map.get_node("PlayerMarker")

				var player_map_position := get_position_from_start(
					_StartCell.position,
					Vector2i(first_node.x, first_node.y),
					Vector2i(_ViewDucts.maze.player_node.x, _ViewDucts.maze.player_node.y))
				_PlayerMarker.position = player_map_position

				if _ViewDucts.maze.player_direction == Maze.PlayerDirection.Up:
					_PlayerMarker.position += Vector2(3.815 * 8,  0) # sorry
					_PlayerMarker.rotation_degrees = 180
				if _ViewDucts.maze.player_direction == Maze.PlayerDirection.Down:
					_PlayerMarker.position += Vector2(0,  3.815 * 8) # sorry
					_PlayerMarker.rotation_degrees = 0
				if _ViewDucts.maze.player_direction == Maze.PlayerDirection.Left:
					_PlayerMarker.position += Vector2(0,  0) # sorry
					_PlayerMarker.rotation_degrees = 90
				if _ViewDucts.maze.player_direction == Maze.PlayerDirection.Right:
					_PlayerMarker.position += Vector2(3.815 * 8, 3.815 * 8) # sorry
					_PlayerMarker.rotation_degrees = 270
	else:
		if !Input.is_action_pressed("left_click"):
			showing_map = false
			_Map.visible = false




func get_position_from_start(start_position: Vector2, start_cell: Vector2i, cell: Vector2i) -> Vector2:
	var x: float = start_position.x + (cell.x - start_cell.x) * 3.815 * 10 # sorry
	var y: float = start_position.y + (cell.y - start_cell.y) * 3.815 * 10 # sorry
	return Vector2(x, y)


func on_mouse_entered() -> void:
	mouse_hover = true
	_Sprite.set_material(MaterialLighten)


func on_mouse_exited() -> void:
	mouse_hover = false
	_Sprite.set_material(null)
