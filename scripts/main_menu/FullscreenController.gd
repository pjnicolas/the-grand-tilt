extends Button


@onready var _Text: RichTextLabel = $Text
@onready var _AudioClick: AudioStreamPlayer = $AudioClick
@onready var _AudioHover: AudioStreamPlayer = $AudioHover

var active := false
const ACTIVE_COLOR := Color(0, 0.5, 1, 1)

func _ready() -> void:
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	connect("pressed", on_pressed)


func _process(_delta: float) -> void:
	var new_active := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if active != new_active:
		if new_active:
			_Text.modulate = ACTIVE_COLOR
		else:
			_Text.modulate = Color(1, 1, 1, 1)
	active = new_active


func on_pressed() -> void:
	_AudioClick.play()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func on_mouse_entered() -> void:
	_AudioHover.play()
	_Text.modulate = Color(0.98, 0.48, 0, 1)


func on_mouse_exited() -> void:
	if active:
		_Text.modulate = ACTIVE_COLOR
	else:
		_Text.modulate = Color(1, 1, 1, 1)
