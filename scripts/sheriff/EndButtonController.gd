extends Button
class_name EndButtonController

@onready var _Text: RichTextLabel = $Text
@onready var _AudioClick: AudioStreamPlayer = $AudioClick
@onready var _AudioHover: AudioStreamPlayer = $AudioHover


enum Type {
	EXPORT_INTERNET,
	LOAD_FILE,
}

@export var type: Type = Type.EXPORT_INTERNET

func _ready() -> void:
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	connect("pressed", on_pressed)


func on_pressed() -> void:
	_AudioClick.play()
	if type == Type.EXPORT_INTERNET:
		Global.corrupt = true
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	elif type == Type.LOAD_FILE:
		get_tree().change_scene_to_file("res://scenes/credits.tscn")


func on_mouse_entered() -> void:
	_Text.modulate = Color(0.98, 0.48, 0, 1)
	_AudioHover.play()


func on_mouse_exited() -> void:
	_Text.modulate = Color(1, 1, 1, 1)
