class_name Maze


var graph: Array[MazeNode] = []

enum PlayerDirection { Up, Down, Left, Right }
enum MoveDirection { Left, Front, Right, Back, Down, Up }

var player_node: MazeNode
var player_direction := PlayerDirection.Down
var name: String


func _init(file_name: String, moving: MoveDirection = MoveDirection.Front) -> void:
	name = file_name
	var file := FileAccess.open("res://mazes/" + file_name + ".csv", FileAccess.READ)

	# Read CSV
	var y: int = 0
	while !file.eof_reached():
		y += 1
		var csv_line: PackedStringArray = file.get_csv_line()

		var x: int = 0
		for cell in csv_line:
			x += 1
			if cell != "":
				graph.append(MazeNode.new(x, y, cell))
	file.close()

	# Search neighbors (this is a mess and not efficient at all)
	for node in graph:
		for other_node in graph:
			if node != other_node:
				if node.x == other_node.x and node.y == other_node.y - 1:
					node.up = other_node
				elif node.x == other_node.x and node.y == other_node.y + 1:
					node.down = other_node
				elif node.x == other_node.x - 1 and node.y == other_node.y:
					node.left = other_node
				elif node.x == other_node.x + 1 and node.y == other_node.y:
					node.right = other_node

	# Set up player start position
	player_node = get_start_node(moving)
	if player_node.up:
		player_direction = PlayerDirection.Up
	elif player_node.down:
		player_direction = PlayerDirection.Down
	elif player_node.left:
		player_direction = PlayerDirection.Left
	elif player_node.right:
		player_direction = PlayerDirection.Right
	else:
		print("Error: Start node has no neighbors")
		assert(false, "Start node has no neighbors")

	move(MoveDirection.Front)


func get_start_node(moving: MoveDirection = MoveDirection.Front) -> MazeNode:
	for node in graph:
		if moving == MoveDirection.Down:
			if node.is_up():
				return node
		elif moving == MoveDirection.Up:
			if node.is_down():
				return node
		elif node.is_start():
			return node
	return null


# This function is only used in the maze map as a workaround
func get_start_node_next() -> MazeNode:
	var start_node: MazeNode = null
	for node in graph:
		if node.is_start():
			start_node = node
			break
		elif node.is_up():
			start_node = node
			break

	if start_node.up:
		return start_node.up
	elif start_node.down:
		return start_node.down
	elif start_node.left:
		return start_node.left
	elif start_node.right:
		return start_node.right
	return null

func move(move_direction: MoveDirection) -> void:
	var new_node: MazeNode
	if move_direction == MoveDirection.Left:
		new_node = player_node.get_neighbor_left(player_direction)
		rotate_player(MoveDirection.Left)
	elif move_direction == MoveDirection.Front:
		new_node = player_node.get_neighbor_front(player_direction)
	elif move_direction == MoveDirection.Right:
		new_node = player_node.get_neighbor_right(player_direction)
		rotate_player(MoveDirection.Right)
	elif move_direction == MoveDirection.Back:
		pass

	if new_node:
		player_node = new_node


func rotate_player(direction: MoveDirection) -> void:
	if direction == MoveDirection.Left:
		if player_direction == PlayerDirection.Up:
			player_direction = PlayerDirection.Left
		elif player_direction == PlayerDirection.Down:
			player_direction = PlayerDirection.Right
		elif player_direction == PlayerDirection.Left:
			player_direction = PlayerDirection.Down
		elif player_direction == PlayerDirection.Right:
			player_direction = PlayerDirection.Up
	elif direction == MoveDirection.Right:
		if player_direction == PlayerDirection.Up:
			player_direction = PlayerDirection.Right
		elif player_direction == PlayerDirection.Down:
			player_direction = PlayerDirection.Left
		elif player_direction == PlayerDirection.Left:
			player_direction = PlayerDirection.Up
		elif player_direction == PlayerDirection.Right:
			player_direction = PlayerDirection.Down
