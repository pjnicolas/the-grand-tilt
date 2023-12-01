extends Button



@onready var _Text: RichTextLabel = $Text
@onready var _AudioClick: AudioStreamPlayer = $AudioClick
@onready var _AudioHover: AudioStreamPlayer = $AudioHover
@onready var _Glitch: ColorRect = $Glitch


func _ready() -> void:
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	connect("pressed", on_pressed)
	_Glitch.visible = Global.corrupt


func _enter_tree() -> void:
	if _Glitch:
		_Glitch.visible = Global.corrupt


func on_pressed() -> void:
	_AudioClick.play()
	if Global.corrupt:
		get_tree().change_scene_to_file("res://scenes/restore.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func on_mouse_entered() -> void:
	_Text.modulate = Color(0.98, 0.48, 0, 1)
	_AudioHover.play()


func on_mouse_exited() -> void:
	_Text.modulate = Color(1, 1, 1, 1)
