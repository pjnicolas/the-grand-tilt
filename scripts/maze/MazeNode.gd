class_name MazeNode

var x: int = 0
var y: int = 0
var cell: String

var right: MazeNode = null
var left: MazeNode = null
var up: MazeNode = null
var down: MazeNode = null


func _init(_x: int, _y: int, _cell: String) -> void:
    x = _x
    y = _y
    cell = _cell


func set_neighbors(_right: MazeNode, _left: MazeNode, _up: MazeNode, _down: MazeNode) -> void:
    right = _right
    left = _left
    up = _up
    down = _down


func is_start() -> bool:
    return cell == "S"


func is_blocked() -> bool:
    return cell == "B"


func is_down() -> bool:
    return cell == "D"


func is_up() -> bool:
    return cell == "U"


func is_vent() -> bool:
    return cell == "1" || cell == "2" || cell == "3" || cell == "4" || cell == "5" || cell == "6" || cell == "7" || cell == "8"


func get_neighbor_front(player_direction: Maze.PlayerDirection) -> MazeNode:
    if player_direction == Maze.PlayerDirection.Right:
        return right
    elif player_direction == Maze.PlayerDirection.Left:
        return left
    elif player_direction == Maze.PlayerDirection.Up:
        return up
    elif player_direction == Maze.PlayerDirection.Down:
        return down
    return null


func get_neighbor_right(player_direction: Maze.PlayerDirection) -> MazeNode:
    if player_direction == Maze.PlayerDirection.Right:
        return down
    elif player_direction == Maze.PlayerDirection.Left:
        return up
    elif player_direction == Maze.PlayerDirection.Up:
        return right
    elif player_direction == Maze.PlayerDirection.Down:
        return left
    return null


func get_neighbor_left(player_direction: Maze.PlayerDirection) -> MazeNode:
    if player_direction == Maze.PlayerDirection.Right:
        return up
    elif player_direction == Maze.PlayerDirection.Left:
        return down
    elif player_direction == Maze.PlayerDirection.Up:
        return left
    elif player_direction == Maze.PlayerDirection.Down:
        return right
    return null
