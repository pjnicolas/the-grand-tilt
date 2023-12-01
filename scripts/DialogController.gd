extends Node2D
class_name DialogController


@onready var _DialogBox: ColorRect = get_node("DialogBox")
@onready var _DialogText: DialogTextController = get_node("DialogBox/DialogText")
@onready var _OptionsBox: OptionBoxController = get_node("CanvasOptions/OptionsBox")
@onready var _Parent: Node2D = get_parent()
@onready var _Button: Button = get_node("Button")
@onready var _AudioStreamPlayer: AudioStreamPlayer = get_node("AudioStreamPlayer")
var _PrettyDialogBox: Sprite2D = null


var PrefabOptionButton: PackedScene = load("res://prefabs/option_button.tscn")
var dialog: Dialog
var current_dialog_line: DialogLine
var waiting_option := false
var dialog_running := false
var on_dialog_line: Callable
var on_dialog_end: Callable
var using_walkie := false


func _ready() -> void:
	_PrettyDialogBox = Sprite2D.new()
	_PrettyDialogBox.position = Vector2(0, 0)
	_PrettyDialogBox.scale = Vector2(2.793, 2.793)
	_PrettyDialogBox.centered = false
	add_child(_PrettyDialogBox)
	move_child(_PrettyDialogBox, 0)


func connect_on_dialog_line(method: Callable) -> void:
	on_dialog_line = method


func connect_on_dialog_end(method: Callable) -> void:
	on_dialog_end = method


func _on_dialog_text_finished() -> void:
	var next_dialog_line := dialog.get_next_dialog_line(current_dialog_line)
	if next_dialog_line && next_dialog_line.is_option():
		show_options(next_dialog_line.all_options)


func load_dialog(new_dialog: Dialog) -> void:
	Global.disable_roles()
	dialog = new_dialog
	current_dialog_line = dialog.get_first_dialog_line()
	if on_dialog_line:
		on_dialog_line.call(dialog.name, current_dialog_line.line_number, current_dialog_line.meta)
	_DialogText.set_dialog_line(current_dialog_line)
	_DialogBox.visible = true
	dialog_running = true
	_Button.visible = true
	_PrettyDialogBox.texture = current_dialog_line.get_box_texture()
	if using_walkie:
		_AudioStreamPlayer.play()


func show_options(all_options: Array[DialogLine]) -> void:
	waiting_option = true
	_Button.visible = false
	_OptionsBox.visible = true
	var padding := Vector2(20, 20)
	var options_height := all_options.size() * 40 + padding.y * 2
	_OptionsBox.set_size_pos(Vector2(_OptionsBox.size.x, options_height), Vector2(_OptionsBox.position.x, get_viewport_rect().size.y - options_height - _OptionsBox.padding.y))
	for i in range(all_options.size()):
		var option := all_options[i]
		var option_button: OptionButtonController = PrefabOptionButton.instantiate()
		var option_position := Vector2(padding.x, padding.y + i * 40)
		var option_size := Vector2(_OptionsBox.size.x - padding.x * 2, 40)
		option_button.set_option(option, option_position, option_size, i + 1)
		_OptionsBox.add_child(option_button)


func _on_option_pressed(option: DialogLine) -> void:
	option.type = ""
	_OptionsBox.visible = false
	for child in _OptionsBox.get_children():
		child.queue_free()
	current_dialog_line = option
	if on_dialog_line:
		on_dialog_line.call(dialog.name, current_dialog_line.line_number, current_dialog_line.meta)
	# _DialogText.set_dialog_line(current_dialog_line)
	waiting_option = false
	_Button.visible = true
	_on_next_line()


# Invisible button pressed
func _on_next_line() -> void:
	if dialog_running && !waiting_option:
		if _DialogText.text_finished:
			var next_dialog_line := dialog.get_next_dialog_line(current_dialog_line)
			if !next_dialog_line:
				_DialogBox.visible = false
				dialog_running = false
				_Button.visible = false
				Global.enable_roles()
				if using_walkie:
					_AudioStreamPlayer.play()
					using_walkie = false
				if on_dialog_end:
					_PrettyDialogBox.texture = null
					on_dialog_end.call(dialog.name, current_dialog_line.line_number)
			else:
				if next_dialog_line.is_option():
					show_options(next_dialog_line.all_options)
				else:
					current_dialog_line = next_dialog_line
					if on_dialog_line:
						on_dialog_line.call(dialog.name, current_dialog_line.line_number, current_dialog_line.meta)
					_DialogText.set_dialog_line(current_dialog_line)
					_PrettyDialogBox.texture = current_dialog_line.get_box_texture()
		else:
			_DialogText.finish_text()
