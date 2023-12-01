extends Node2D
class_name ViewDuctsController


@onready var _Ducts: Node2D = get_node("Ducts")
@onready var _Fade_AnimationPlayer: AnimationPlayer = get_node("Fade/AnimationPlayer")
@onready var _Dialog: DialogController = get_node("Dialog")
@onready var _TurnAround: TurnAroundController = get_node("TurnAround")
@onready var _Bomb: Sprite2D = get_node("Bomb")
@onready var _Bomb_AnimationPlayer: AnimationPlayer = get_node("Bomb/AnimationPlayer")
@onready var _Bomb_AudioStreamPlayer: AudioStreamPlayer = get_node("Bomb/AudioStreamPlayer")
@onready var _Bomb_AudioClick: AudioStreamPlayer = get_node("Bomb/AudioClick")
@onready var _AudioMovement: AudioStreamPlayer = get_node("AudioMovement")
@onready var _AudioDescend: AudioStreamPlayer = get_node("AudioDescend")
@onready var _Camera: DuctsCameraController = get_node("Camera2D")
@onready var _OpenMap: OpenMapController = get_node("OpenMap")
@onready var _Maps: CanvasLayer = get_node("Maps")


var PrefabDuct: PackedScene = load("res://prefabs/duct.tscn")
var PrefabDuctRight: PackedScene = load("res://prefabs/duct_right.tscn")
var PrefabDuctLeft: PackedScene = load("res://prefabs/duct_left.tscn")
var PrefabDuctEnd: PackedScene = load("res://prefabs/duct_end.tscn")
var PrefabDuctDoor: PackedScene = load("res://prefabs/duct_door.tscn")
var PrefabDuctNext: PackedScene = load("res://prefabs/duct_next.tscn")
var PrefabDuctVent: PackedScene = load("res://prefabs/duct_vent.tscn")
var PrefabDuctDown: PackedScene = load("res://prefabs/duct_down.tscn")
var PrefabDuctUp: PackedScene = load("res://prefabs/duct_up.tscn")
var PrefabWhiteNoise: PackedScene = load("res://prefabs/white_noise.tscn")
var TextureDoorOpen: Texture2D = load("res://sprites/screens/vents/vent_open.png")
var TextureBombWire0: Texture2D = load("res://sprites/screens/vents/bomb.png")
var TextureBombWire1: Texture2D = load("res://sprites/screens/vents/bomb_1.png")
var TextureBombWire2: Texture2D = load("res://sprites/screens/vents/bomb_2.png")
var TextureBombWire3: Texture2D = load("res://sprites/screens/vents/bomb_3.png")
var PrefabGlitch: PackedScene = load("res://prefabs/glitch.tscn")


var maze: Maze
var fading: bool = false
var fade_move_direction: Maze.MoveDirection
var fade_is_turning_around: bool = false
var can_go_basement: bool = false
var dialog_on_enter_tree: Dialog = null
var in_dialog := false


# I think I'm not using this?
func _enter_tree() -> void:
	if dialog_on_enter_tree:
		_Dialog.visible = true
		in_dialog = true
		_Dialog.load_dialog(dialog_on_enter_tree)
		dialog_on_enter_tree = null


func _ready() -> void:
	maze = Maze.new("floor2")
	_Dialog.connect_on_dialog_end(Callable(self, "on_dialog_end"))
	_Dialog.connect_on_dialog_line(Callable(self, "on_dialog_line"))
	refresh_ducts()

	# Sorry for this mess
	_Dialog.visible = true
	in_dialog = true
	_Dialog.load_dialog(Dialog.get_dialog("7"))


func on_click_vents(dialog: Dialog) -> void:
	_Dialog.visible = true
	in_dialog = true
	_Dialog.load_dialog(dialog)


func on_dialog_line(_file_name: String, _line_number: int, meta: String) -> void:
	if meta == "BOMB":
		_Bomb.visible = true
		_Bomb_AudioStreamPlayer.play()
		_Bomb_AnimationPlayer.play("fade_in")
	if meta == "WIRE1":
		_Bomb.texture = TextureBombWire1
		_Bomb_AudioClick.play()
	if meta == "WIRE2":
		_Bomb.texture = TextureBombWire2
		_Bomb_AudioClick.play()
	if meta == "WIRE3":
		_Bomb.texture = TextureBombWire3
		_Bomb_AudioClick.play()
		_Bomb_AudioStreamPlayer.stop()
	if meta == "GLITCH":
		add_child(BackBufferCopy.new())
		add_child(PrefabGlitch.instantiate())
	if meta == "MUTE":
		Global.stop()
	if meta == "GLITCH_BOMB":
		add_child(BackBufferCopy.new())
		add_child(PrefabGlitch.instantiate())
		_Bomb.texture = TextureBombWire0
		_Bomb_AudioStreamPlayer.pitch_scale = 4
		_Bomb_AudioStreamPlayer.volume_db = 5
		_Bomb_AudioStreamPlayer.play()


func on_dialog_end(file_name: String, _line_number: int) -> void:
	if file_name == "8":
		Global.get_main().start_phase_seek_open_door()
	if file_name == "vent5":
		Global.get_main().start_phase_saw_last_vent()
	if file_name == "10.5":
		Global.get_roles()._Ducts.set_dead(true)
		_Bomb_AnimationPlayer.play("explosion")
		_Camera.shake = true
		_Bomb_AudioStreamPlayer.stop()
		Global.disable_roles()
	if file_name == "11":
		Global.get_main().start_phase_ducts_dead_2()

	in_dialog = false


func on_explosion_end() -> void:
	_Camera.shake = false
	_Bomb.visible = false
	var white_noise := PrefabWhiteNoise.instantiate()
	add_child(white_noise)
	move_child(white_noise, 0)


func on_explosion_end_next_dialog() -> void:
	Global.enable_roles()
	_Dialog.visible = true
	in_dialog = true
	_Dialog.load_dialog(Dialog.get_dialog("11"))


func handle_move(move_direction: Maze.MoveDirection) -> void:
	if !fading:
		if move_direction == Maze.MoveDirection.Down && maze.name == "floor1" && !can_go_basement:
			# _AudioDescend.play()
			in_dialog = true
			if Global.get_main()._ViewSheriff._Walkie.next_dialog:
				_Dialog.load_dialog(Dialog.get_dialog("10.4"))
			else:
				_Dialog.load_dialog(Dialog.get_dialog("10.3"))
			return
		if move_direction == Maze.MoveDirection.Down:
			_AudioDescend.play()
		else:
			_AudioMovement.play()
		fading = true
		fade_move_direction = move_direction
		fade_is_turning_around = false
		if move_direction == Maze.MoveDirection.Down:
			_Fade_AnimationPlayer.play("RESET")
			_Fade_AnimationPlayer.play("fade_long")
		else:
			_Fade_AnimationPlayer.play("RESET")
			_Fade_AnimationPlayer.play("fade")


func _on_anim_fade_middle() -> void:
	if fade_is_turning_around:
		maze.rotate_player(Maze.MoveDirection.Right)
		maze.rotate_player(Maze.MoveDirection.Right)
		if maze.player_node.get_neighbor_front(maze.player_direction):
			maze.move(Maze.MoveDirection.Front)
	else:
		if fade_move_direction == Maze.MoveDirection.Down:
			if maze.name == "floor2":
				_OpenMap._Map = _OpenMap._MapFloor1
				maze = Maze.new("floor1", fade_move_direction)
				maze.move(Maze.MoveDirection.Front)
			elif maze.name == "floor1":
				# Poner pantalla en negro y empiezar el dialogo 10.5
				in_dialog = true
				_Dialog.load_dialog(Dialog.get_dialog("10.5"))
				_Ducts.visible = false
				_TurnAround.visible = false
				_OpenMap.visible = false
				_Maps.visible = false
				return
		if fade_move_direction == Maze.MoveDirection.Up:
			maze = Maze.new("floor2", fade_move_direction)
		maze.move(fade_move_direction)
	refresh_ducts()


func _on_anim_fade_end() -> void:
	fading = false


func _on_turn_around() -> void:
	if !fading && !in_dialog:
		fading = true
		fade_is_turning_around = true
		_Fade_AnimationPlayer.play("fade")


func open_door() -> void:
	Global.ducts_door_open = true
	refresh_ducts()


func refresh_ducts() -> void:
	for child in _Ducts.get_children():
		child.queue_free()

	_Ducts.add_child(PrefabDuct.instantiate())
	var front: MazeNode = maze.player_node.get_neighbor_front(maze.player_direction)
	if front:
		if maze.player_node.is_blocked() && front.is_blocked():
			if !Global.ducts_door_found:
				Global.ducts_door_found = true
				Global.get_main().start_phase_ducts_found_door()
			var duct_door: DuctDoorController = PrefabDuctDoor.instantiate()
			_Ducts.add_child(duct_door)
			if Global.ducts_door_open:
				var duct_door_sprite: Sprite2D = duct_door.get_node("Sprite2D")
				duct_door_sprite.texture = TextureDoorOpen
				duct_door.is_open = true
		else:
			_Ducts.add_child(PrefabDuctNext.instantiate())
	else:
		_Ducts.add_child(PrefabDuctEnd.instantiate())
	if maze.player_node.get_neighbor_left(maze.player_direction):
		_Ducts.add_child(PrefabDuctLeft.instantiate())
	if maze.player_node.get_neighbor_right(maze.player_direction):
		_Ducts.add_child(PrefabDuctRight.instantiate())
	if maze.player_node.is_vent():
		var vents: DuctVentController = PrefabDuctVent.instantiate()
		vents.dialog = Dialog.get_dialog("vent" + maze.player_node.cell)
		_Ducts.add_child(vents)
	if !front && maze.player_node.is_down():
		_Ducts.add_child(PrefabDuctDown.instantiate())
	if !front && (maze.player_node.is_up() || maze.player_node.is_start()):
		_Ducts.add_child(PrefabDuctUp.instantiate())
